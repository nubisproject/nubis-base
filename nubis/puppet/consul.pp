class { 'consul':
  version     => '0.6.3',
  service_enable => false,
  service_ensure => 'stopped',
  manage_service => false,
  config_hash => {
      'data_dir'      => '/var/lib/consul',
      'log_level'     => 'INFO',
      'ui_dir'        => '/var/lib/consul/ui',
      'client_addr'   => '0.0.0.0',
      'server'        => false,
      'enable_syslog' => true,
  }
}

# initv startup script is borked
case $::osfamily {
  'redhat': {
    package { "daemonize":
      ensure => 'present',
      install_options => [ '--enablerepo=epel' ],
    }
  }
}

# Install latest known consul-do
class { 'consul_do':
  version => "404d6180650e72e1881a260dab8d645815832c9e"
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

class { 'consul_template':
    service_enable   => false,
    service_ensure   => 'stopped',
    version          => '0.11.0',
    user             => 'root',
    group            => 'root',
}

# Download and install consul-do
class consul_do (
  $version
  )
{
  $url = "https://raw.githubusercontent.com/zeroXten/consul-do/$version/consul-do"

  notice ("Grabbing from $url")

  wget::fetch { "download consul-do $version":
      source => $url,
      destination => "/usr/local/bin/consul-do-$version",
      user => "root",
      verbose => true,
      redownload => true, # The file already exists, we replace it
  } ->
  file { "/usr/local/bin/consul-do-${version}":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0755',
  } ->
  file { "/usr/local/bin/consul-do":
    ensure => "link",
    target => "/usr/local/bin/consul-do-$version",
  }
}
