class { 'consul':
  version     => '0.5.0'

  config_hash => {
      'data_dir'      => '/var/lib/consul',
      'log_level'     => 'INFO',
      'ui_dir'        => '/var/lib/consul/ui',
      'client_addr'   => '0.0.0.0',
      'server'        => false,
      'enable_syslog' => true,
  }
}

# XXX: need to move to puppet-envconsul proper
staging::file { 'envconsul.tar.gz':
  source => "https://github.com/hashicorp/envconsul/releases/download/v0.5.0/envconsul_0.5.0_linux_amd64.tar.gz"
} ->
staging::extract { 'envconsul.tar.gz':
  strip   => 0,
  target  => "/opt/hashicorp",
  creates => "/opt/hashicorp/envconsul_0.5.0_linux_amd64",
} ->
file { "/opt/hashicorp/envconsul_0.5.0_linux_amd64/envconsul":
  owner =>  0,
  group =>  0,
  mode  => '0555',
} ->
file { "/usr/local/bin/envconsul"
  ensure => "link",
  target => '/opt/hashicorp/envconsul_0.5.0_linux_amd64/envconsul',
}
