class { 'confd':
  version    => '0.10.0',
  sitemodule => 'confd_site',
  backend    => 'consul',
  watch      => true,
  nodes      => [ 'localhost:8500' ],
}
