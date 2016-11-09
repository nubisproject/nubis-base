file { '/usr/local/bin/nubis-secret':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/nubis-secret',
}
