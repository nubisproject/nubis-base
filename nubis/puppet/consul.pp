class { 'consul':
  version           => '0.8.5',
  service_enable    => false,
  service_ensure    => 'stopped',
  manage_service    => true,
  restart_on_change => false,
  config_hash       => {
      'data_dir'              => '/var/lib/consul',
      'log_level'             => 'WARN',
      'ui_dir'                => '/var/lib/consul/ui',
      'client_addr'           => '0.0.0.0',
      'server'                => false,
      'enable_syslog'         => true,
      'leave_on_terminate'    => true,
      'acl_enforce_version_8' => false,
      'disable_host_node_id'  => true,
      'disable_update_check'  => true,
  }
}

# Install latest known consul-do
class { 'consul_do':
  version => '404d6180650e72e1881a260dab8d645815832c9e'
}

class { 'consul_template':
    service_enable => false,
    service_ensure => 'stopped',
    version        => '0.16.0',
    user           => 'root',
    group          => 'root',
}

# Package['tar'] is defined by consul_template above
class { 'envconsul':
  version  => '0.6.1',
}
