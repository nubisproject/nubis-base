# MiG needs this on RHEL for lsb_release
if $osfamily == 'redhat' {
  package {"redhat-lsb-core":
    ensure => "latest"
  }
}

class {'mig':
  version => "20151105",
  build   => "0.a7466ac"
}
