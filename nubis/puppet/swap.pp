sysctl { 'vm.swappiness':
  value => 10,
}

file { '/etc/nubis.d/0-swap':
  ensure  => 'present',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/swap',
  require => [
    File['/etc/nubis.d'],
  ]
}
