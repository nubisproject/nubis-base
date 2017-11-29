class { 'postfix':
  service_ensure => 'stopped',
}
->package {'sendmail':
  ensure => absent,
}
