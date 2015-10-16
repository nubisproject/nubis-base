# We want this enabled, but no need to start it during a packer run
class { 'fluentd':
  service_ensure => stopped
}

# Make fluentd run as root so it can read all log files
if $osfamily == 'RedHat' {
file { "/etc/sysconfig":
  ensure => "directory",
  owner  => "root",
  group  => "root",
  mode    => '0755',
}->
file { "/etc/sysconfig/td-agent":
  ensure => "present",
  owner  => "root",
  group  => "root",
  source => "puppet:///nubis/files/fluentd.sysconfig",
}
}
elsif $osfamily == 'Debian' {
  exec { "change-fluentd-user":
    command => "/usr/bin/perl -pi -e's/^(USER|GROUP)=td-agent/\$1=root/g' /etc/init.d/td-agent",
    require => Class['Fluentd::Packages'],
  }
}

if $osfamily == 'Debian' {
  $ruby_dev = "ruby-dev"
  $syslog_main = "/var/log/syslog"
  $syslog_mail = "/var/log/mail.log"
}
else {
  $ruby_dev = "ruby-devel"
   $syslog_main = "/var/log/messages"
   $syslog_mail = "/var/log/maillog"
}

# For the ec2 plugin
package { [$ruby_dev, "make", "gcc"]:
  ensure => "present",
}

fluentd::install_plugin { 'ec2-metadata':
  plugin_type => 'gem',
  plugin_name => 'fluent-plugin-ec2-metadata',
  ensure      => '0.0.7',
}

fluentd::configfile { 'syslog': }

fluentd::configfile { 'forward': }

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

file { "/etc/td-agent/config.d/ec2_metadata.conf":
  ensure => "present",
  owner	 => "td-agent",
  group  => "td-agent",
  content => '
    <match forward.**>
      type ec2_metadata
      output_tag ec2.${tag}
      <record>
        instance_id   ${instance_id}
        instance_type ${instance_type}
        az            ${availability_zone}
        region        ${region}
      </record>
    </match>',
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
  ensure => 'present',
  command => "service td-agent status 1>/dev/null || service td-agent start",
  hour => '*',
  minute => '*/11',
  user => 'root',
  environment => [
    "PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/opt/aws/bin",
  ],
}
