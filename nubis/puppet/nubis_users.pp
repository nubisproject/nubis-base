file { '/etc/nubis.d/01-gen-puppet':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/gen-puppet.sh',
}

file { '/usr/local/bin/nubis-gen-puppet':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/nubis-gen-puppet',
}

cron { 'nubis-gen-puppet-watchdog':
  ensure      => present,
  command     => 'nubis-cron gen-puppet-watchdog /usr/local/bin/nubis-gen-puppet',
  hour        => '*',
  minute      => [fqdn_rand(30), ( fqdn_rand(30) + 30 ) % 60],
  user        => 'root',
  require     => File['/usr/local/bin/nubis-gen-puppet'],
  environment => [
    'PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/opt/aws/bin',
  ]
}
