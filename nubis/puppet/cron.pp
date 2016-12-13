file { '/usr/bin/nubis-cron':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/nubis-cron',
}
