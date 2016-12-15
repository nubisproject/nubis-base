class { 'confd':
  version    => '0.11.0',
  sitemodule => 'confd_site',
  backend    => 'consul',
  watch      => true,
  nodes      => [ 'localhost:8500' ],
}

cron { 'confd-watchdog':
  ensure      => 'present',
  command     => 'nubis-cron confd-watchdog "( service confd start || true ) 1>/dev/null 2>/dev/null"',
  hour        => '*',
  minute      => '*/11',
  user        => 'root',
  environment => [
    'PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/opt/aws/bin',
  ],
}
