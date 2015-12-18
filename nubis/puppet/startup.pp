file { '/etc/nubis.d':
  ensure  => directory,
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
}->
file { '/etc/nubis.d/00-consul':
  ensure => 'present',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/consul-bootstrap'
}

file { '/etc/rc.local':
  ensure => 'present',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/rc.local'
}
