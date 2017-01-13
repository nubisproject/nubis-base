file { '/usr/local/bin/nubis-housekeeper':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/housekeeper',
}

# We don't need or want it, especially not Ubuntu's idea of 'mesg n' in there
file { '/root/.profile':
  ensure => absent,
}
