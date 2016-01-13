file { '/usr/local/bin/nubis-housekeeper':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => 'puppet:///nubis/files/housekeeper',
}
