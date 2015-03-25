# We want this enabled, but no need to start it during a packer run
class { 'fluentd':
  service_ensure => stopped
}

if $osfamily == 'Debian' {
  $ruby_dev = "ruby-dev"
}
else {
  $ruby_dev = "ruby-devel"
}

# For the ec2 plugin
package { [$ruby_dev, "make"]:
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

