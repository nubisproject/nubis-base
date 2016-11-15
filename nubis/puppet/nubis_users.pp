file { '/etc/nubis.d/01-gen-puppet.sh':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/gen-puppet.sh',
}

cron { 'gen-puppet-watchdog':
  ensure      => present,
  command     => '/etc/nubis.d/01-gen-puppet.sh',
  hour        => '*',
  minute      => '*/10',
  user        => 'root',
  require     => File['/etc/nubis.d/01-gen-puppet.sh'],
  environment => [
    'PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/opt/aws/bin'
  ],
}
