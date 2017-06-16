class { 'postfix':
}
->package {'sendmail':
  ensure => absent,
}
