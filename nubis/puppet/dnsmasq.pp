class { 'dnsmasq':
  interface         => 'lo',
  reload_resolvconf => false,
  restart           => false,
  service_ensure    => 'stopped',
}

dnsmasq::dnsserver { 'consul':
  domain => 'consul',
  ip     => '127.0.0.1#8600',
}

if $::operatingsystem == 'Amazon' {
    file_line { 'dhclient_resolvconf':
        path => '/etc/dhcp/dhclient.conf',
        line => 'prepend domain-name-servers 127.0.0.1;'
    }
}
