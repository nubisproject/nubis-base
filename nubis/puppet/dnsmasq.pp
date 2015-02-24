class { 'dnsmasq':

}

dnsmasq::dnsserver { 'consul':
  domain => 'consul',
  ip     => '127.0.0.1#8600',
}
