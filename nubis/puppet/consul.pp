class { 'consul':
  version     => '0.5.0',
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
  source => "https://www.github.com/hashicorp/envconsul/releases/download/v0.5.0/envconsul_0.5.0_linux_amd64.tar.gz",
} ->
staging::extract { 'envconsul.tar.gz':
  strip   => 0,
  target  => "/opt",
  creates => "/opt/envconsul_0.5.0_linux_amd64",
} ->
file { "/opt/hashicorp/envconsul_0.5.0_linux_amd64/envconsul":
  owner =>  0,
  group =>  0,
  mode  => '0555',
} ->
file { "/usr/local/bin/envconsul":
  ensure => "link",
  target => '/opt/envconsul_0.5.0_linux_amd64/envconsul',
}

# XXX: need to move to puppet-consul-template proper
staging::file { 'consul-template.tar.gz':
  source => "https://www.github.com/hashicorp/consul-template/releases/download/v0.7.0/consul-template_0.7.0_linux_amd64.tar.gz",
} ->
staging::extract { 'consul-template.tar.gz':
  strip   => 0,
  target  => "/opt",
  creates => "/opt/consul-template_0.7.0_linux_amd64",
} ->
file { "/opt/hashicorp/consul-template_0.7.0_linux_amd64/consul-template":
  owner =>  0,
  group =>  0,
  mode  => '0555',
} ->
file { "/usr/local/bin/consul-template":
  ensure => "link",
  target => '/opt/consul-template_0.7.0_linux_amd64/consul-template',
}
