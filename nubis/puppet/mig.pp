# MiG needs this on RHEL for lsb_release
if $osfamily == 'redhat' {
  package {"redhat-lsb-core":
    ensure => "latest"
  }
}

class {'mig':
  version => "20160126",
  build   => "1.c128226"
}
