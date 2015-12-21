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

case $::osfamily {
  'redhat': {
    $rc_local = "/etc/rc.d/rc.local"
  }
  default: {
    $rc_local = "/etc/rc.local"
  }
}

file { $rc_local:
  ensure => 'present',
  links   => 'follow',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  source  => 'puppet:///nubis/files/rc.local'
}
