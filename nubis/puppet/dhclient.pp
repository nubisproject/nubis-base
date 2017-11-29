# Make sure we check with dnsmask locally first
if $osfamily == 'RedHat' {
  if $::packer_builder_type != 'docker' {
    file { '/etc/dhcp/dhclient.conf':
      ensure  => 'present',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => @(EOF)
timeout 300;
retry 60;
prepend domain-name-servers 127.0.0.1;
EOF
    }
  }
}



