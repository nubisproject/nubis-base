file { '/var/cache/nubis':
  ensure => directory,
  owner  => root,
  group  => root,
  mode   => '0755',
}
->file { '/usr/bin/nubis-metadata':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/nubis-metadata',
}

file { '/usr/bin/nubis-region':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/nubis-region',
}

file { '/usr/bin/nubis-availability-zone':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/nubis-availability-zone',
}

