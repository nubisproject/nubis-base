file { '/etc/nubis.d':
  ensure  => directory,
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
}

file { '/etc/rc.local':
  ensure => 'present',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/rc.local'
}
