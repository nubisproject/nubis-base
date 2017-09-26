# We want this enabled, but no need to start it during a packer run
class { 'fluentd':
  service_ensure => stopped
}

# Make fluentd run as root so it can read all log files
if $osfamily == 'RedHat' {
  $td_agent_default = '/etc/sysconfig/td-agent'
}
elsif $osfamily == 'Debian' {
  $td_agent_default = '/etc/default/td-agent'
}
else {
  fail("Don't know where fluentd default settings file is on osfamily:${osfamily}")
}

file { $td_agent_default:
  ensure  => 'present',
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/fluentd.sysconfig',
  require => [
    Class['fluentd'],
  ],
}

if $osfamily == 'Debian' {
  $ruby_dev = 'ruby-dev'
  $syslog_main = '/var/log/syslog'
  $syslog_mail = '/var/log/mail.log'
}
else {
  $ruby_dev = 'ruby-devel'
  $syslog_main = '/var/log/messages'
  $syslog_mail = '/var/log/maillog'
}

# For the ec2 plugin
package { [$ruby_dev, 'make', 'gcc']:
  ensure => 'present',
}

fluentd::install_plugin { 'ec2-metadata':
  ensure      => '0.0.15',
  plugin_type => 'gem',
  plugin_name => 'fluent-plugin-ec2-metadata',
  require     => [
    Package['make'],
    Package['gcc'],
    Package[$ruby_dev],
  ],
}

fluentd::configfile { 'syslog': }
fluentd::configfile { 'forward': }
fluentd::configfile { 'unix': }

fluentd::match { 'forward':
  configfile => 'forward',
  type       => 'forward',
  pattern    => 'ec2.forward.**',
  config     => {
    'send_timeout'       => '60s',
    'recover_wait'       => '10s',
    'heartbeat_interval' => '1s',
    'phi_threshold'      => '16',
    'hard_timeout'       => '60s',
  },
  # XXX: This should be coming from confd, but use consul DNS discovery for now
  servers    => [
    {
      'name' => 'primary',
      'host' => 'collector.fluentd.service.consul',
      'port' => '24224',
    }
  ]
}

# Unfortunately, current fluentd::match doesn't allow for modules with
# internal <blocks> it doesn't know about
#
#fluentd::match {'ec2':
#  configfile => 'forward',
#  type       => 'ec2_metadata',
#  pattern    => 'forward.**',
#  config     => {
#  }
#}

file { '/etc/td-agent/config.d/ec2_metadata.conf':
  ensure  => 'present',
  owner   => 'td-agent',
  group   => 'td-agent',

  # lint:ignore:single_quote_string_with_variables
  content => '
    <match forward.**>
      type ec2_metadata
      output_tag ec2.${tag}
      <record>
        instance_id   ${instance_id}
        instance_type ${instance_type}
        az            ${availability_zone}
        region        ${region}
        vpc_id        ${vpc_id}
        subnet_id     ${subnet_id}
        private_ip    ${private_ip}
        ami_id        ${image_id}
        mac           ${mac}
        project       "#{ENV[\'NUBIS_PROJECT\']}"
        stack         "#{ENV[\'NUBIS_STACK\']}"
        purpose       "#{ENV[\'NUBIS_PURPOSE\']}"
        environment   "#{ENV[\'NUBIS_ENVIRONMENT\']}"
        arena         "#{ENV[\'NUBIS_ARENA\']}"
      </record>
    </match>',
  # lint:endignore
}

fluentd::source { 'syslog_main':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.syslog',
  config     => {
    'path'     => $syslog_main,
    'pos_file' => '/tmp/td-agent.syslog.pos',
  },
  notify     => Class['fluentd::service']
}

fluentd::source { 'syslog_kern':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.kern',
  config     => {
    'path'     => '/var/log/kern.log',
    'pos_file' => '/tmp/td-agent.syslog.pos',
  },
  notify     => Class['fluentd::service']
}

fluentd::source { 'syslog_mail':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.mail',
  config     => {
    'path'     => $syslog_mail,
    'pos_file' => '/tmp/td-agent.syslog.pos',
  },
  notify     => Class['fluentd::service']
}

fluentd::source { 'syslog_mail_err':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.mail.err',
  config     => {
    'path'     => '/var/log/mail.err',
    'pos_file' => '/tmp/td-agent.syslog.pos',
  },
  notify     => Class['fluentd::service']
}

fluentd::source { 'unix':
  configfile => 'unix',
  type       => 'unix',
  config     => {
    'path'     => '/var/run/fluent/fluent.sock',
  },
  notify     => Class['fluentd::service']
}

# Simplify our lives and drop fluent-cat in $PATH
file { '/usr/bin/fluent-cat':
  ensure => 'link',
  target => '/opt/td-agent/embedded/bin/fluent-cat',
}

if $osfamily == 'RedHat' {
  fluentd::source { 'syslog_secure':
    configfile => 'syslog',
    type       => 'tail',
    format     => 'syslog',
    tag        => 'forward.system.secure',
    config     => {
      'path'     => '/var/log/secure',
      'pos_file' => '/tmp/td-agent.syslog.pos',
    },
    notify     => Class['fluentd::service']
  }
}

cron { 'fluent-watchdog':
  ensure      => 'present',
  command     => 'nubis-cron fluent-watchdog "service td-agent status 1>/dev/null || service td-agent start || true"',
  hour        => '*',
  minute      => '*/11',
  user        => 'root',
  environment => [
    'PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/opt/aws/bin',
  ],
}
