file { '/usr/local/bin/nubis-purpose':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/purpose',
}
