file { '/usr/local/lib/nubis':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0744',
}

file { '/usr/local/lib/nubis/nubis-lib.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0744',
    source  => 'puppet:///nubis/files/nubis-lib.sh',
    require => File['/usr/local/lib/nubis']
}
