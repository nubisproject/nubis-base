class { 'confd':
  version    => '0.10.0',
  sitemodule => 'confd_site',
  backend    => 'consul',
  watch      => true,
  nodes      => [ 'localhost:8500' ],
}

cron { 'confd-watchdog':
  ensure => 'present',
  command => "service confd status 1>/dev/null || service confd start",
  hour => '*',
  minute => '*/11',
  user => 'root',
  environment => [
    "PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/opt/aws/bin",
  ],
}
