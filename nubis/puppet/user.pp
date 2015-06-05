# create nubis user on the base image

group { 'nubis':
    ensure => present,
}

user { 'nubis':
    ensure  => present,
    groups  => [ 'nubis' ],
    home    => '/home/nubis',
    shell   => '/bin/bash',
    require => Group['nubis'],
}

class { 'sudo':
  purge               => false,
  config_file_replace => false,
}

sudo::conf { 'nubis':
  content  => "nubis ALL=(ALL) NOPASSWD: ALL",
  require => [ User['nubis'], Group['nubis'] ],
}
