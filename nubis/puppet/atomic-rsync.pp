file { '/usr/local/bin/atomic-rsync':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/atomic-rsync',
}
