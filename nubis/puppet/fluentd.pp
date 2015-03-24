# We want this enabled, but no need to start it during a packer run
class { 'fluentd':
  service_ensure => stopped
}

# For the ec2 plugin
package { ["ruby-dev", "make"]:
  ensure => "present",
}

fluentd::install_plugin { 'ec2-metadata':
  plugin_type => 'gem',
  plugin_name => 'fluent-plugin-ec2-metadata',
}

fluentd::configfile { 'syslog': }

fluentd::configfile { 'forward': }

fluentd::match { 'forward':
  configfile => 'forward',
  type       => 'forward',
  pattern    => 'forward.**',
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

fluentd::source { 'syslog_main':
  configfile => 'syslog',
  type       => 'tail',
  format     => 'syslog',
  tag        => 'forward.system.syslog',
  config     => {
    'path'     => '/var/log/syslog',
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
    'path'     => '/var/log/mail.log',
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

