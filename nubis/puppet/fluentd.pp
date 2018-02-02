# We want this enabled, but no need to start it during a packer run
class { 'fluentd':
  service_ensure => stopped
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

file { '/usr/local/bin/nubis-fluentd':
  ensure => present,
  mode   => '0755',
  owner  => 'root',
  group  => 'root',
  source => 'puppet:///nubis/files/nubis-fluentd',
}


fluentd::install_plugin { 'ec2-metadata':
  ensure      => '0.1.1',
  plugin_type => 'gem',
  plugin_name => 'fluent-plugin-ec2-metadata',
  require     => [
    Package['make'],
    Package['gcc'],
    Package[$ruby_dev],
  ],
}

fluentd::install_plugin { 'systemd':
  ensure      => '0.3.1',
  plugin_type => 'gem',
  plugin_name => 'fluent-plugin-systemd',
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
    'send_timeout'                     => '60s',
    'recover_wait'                     => '10s',
    'heartbeat_interval'               => '1s',
    'phi_threshold'                    => '16',
    'hard_timeout'                     => '60s',
    'ignore_network_errors_at_startup' => true,
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
      @type ec2_metadata
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

# Parse and forward the entire systemd journal logs
file { '/etc/td-agent/config.d/systemd.conf':
  ensure  => 'present',
  owner   => 'td-agent',
  group   => 'td-agent',

  # lint:ignore:single_quote_string_with_variables
  content => '
    <source>
      @type systemd
      tag forward.systemd.journal
      path /run/log/journal
      read_from_head true
    <entry>
      fields_lowercase true
      fields_strip_underscores true
    </entry>
    <storage>
      @type local
      persistent false
      path systemd.pos
    </storage>
  </source>
',
  # lint:endignore
}

fluentd::source { 'syslog_main':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.syslog',
  config     => {
    'path'     => $syslog_main,
    'pos_file' => '/tmp/td-agent.syslog.main.pos',
  },
  notify     => Class['fluentd::service']
}

# XXX: Debianism
#if $osfamily == 'Debian' {
fluentd::source { 'syslog_kern':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.kern',
  config     => {
    'path'     => '/var/log/kern.log',
    'pos_file' => '/tmp/td-agent.syslog.kern.pos',
  },
  notify     => Class['fluentd::service']
}
#}

fluentd::source { 'syslog_auth':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.auth',
  config     => {
    'path'     => '/var/log/auth.log',
    'pos_file' => '/tmp/td-agent.syslog.auth.pos',
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
    'pos_file' => '/tmp/td-agent.syslog.mail.pos',
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
    'pos_file' => '/tmp/td-agent.syslog.mail.err.pos',
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
      'pos_file' => '/tmp/td-agent.syslog.secure.pos',
    },
    notify     => Class['fluentd::service']
  }
}

# Ensure service auto-restarts
file { '/etc/systemd/system/td-agent.service.d':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
}

::systemd::dropin_file { 'nubis.conf':
  unit    => 'td-agent.service',
  content => @(END)
[Service]
User=root
Group=root
# Run our own overriden wrapper
ExecStart=
ExecStart=/usr/local/bin/nubis-fluentd
Restart=on-failure
RestartSec=60s
END
}
