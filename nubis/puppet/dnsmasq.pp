class { 'dnsmasq':
  reload_resolvconf => false,
}

dnsmasq::dnsserver { 'consul':
  domain => 'consul',
  ip     => '127.0.0.1#8600',
}
