# Install default proxy configuration file.

file {
    '/etc/profile.d/proxy.sh':
        ensure => present,
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///nubis/files/profile.d_proxy.sh',
}

if $osfamily == 'RedHat' {
  # For /usr/bin/host
  package { 'bind-utils':
    ensure => '9.9.4-*'
  }
}
