class { 'confd':
  version => "0.7.1",
  sitemodule => "confd_site",
  backend => "consul",
  watch => true,
  nodes => [ "localhost:8500" ],
}
