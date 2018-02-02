$confd_version = '0.13.0'
$confd_url = "https://github.com/kelseyhightower/confd/releases/download/v${confd_version}/confd-${confd_version}-linux-amd64"

notice ("Grabbing confd ${confd_version}")

staging::file { '/usr/local/bin/confd':
  source => $confd_url,
  target => '/usr/local/bin/confd',
  mode   => '0755',
  owner  => 'root',
  group  => 'root',
}

file { '/etc/confd':
  ensure  => directory,
  recurse => true,
  purge   => false,
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/confd',
}

file { '/etc/confd/confd.toml':
  mode    => '0644',
  owner   => 'root',
  group   => 'root',
  require => [
    File['/etc/confd'],
  ],
  source  => 'puppet:///nubis/files/confd.toml',
}

file { '/lib/systemd/system/confd.service':
  mode   => '0644',
  owner  => 'root',
  group  => 'root',
  source => 'puppet:///nubis/files/confd.systemd',
}

# Generic
include nubis_configuration
nubis::configuration{ 'base':
  format => 'sh',
}
