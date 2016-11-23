# Install default proxy configuration file.

file {
    '/etc/profile.d/proxy.sh':
        ensure => present,
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///nubis/files/profile.d_proxy.sh',
}

case $::osfamily {
  'RedHat': {
    package { 'perl-NetAddr-IP':
      ensure => 'present',
    }
  }
  'Debian': {
    package { 'libnetaddr-ip-perl':
      ensure => 'present',
    }
  }
  default: {
    fail("Unsupported OS for perl(NetAddr::IP) ${::osfamily}")
  }
}

file { '/usr/local/bin/nubis-network-ips':
  ensure => present,
  mode   => '0755',
  owner  => 'root',
  group  => 'root',
  source => 'puppet:///nubis/files/nubis-network-ips',
}
