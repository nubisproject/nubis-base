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

file { '/etc/sudoers.d/nubis-sudoers':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0440,
    content => "nubis   ALL=(ALL)   NOPASSWD:ALL\n",
    require => [ User['nubis'], Group['nubis'] ],
}
