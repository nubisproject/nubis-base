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
