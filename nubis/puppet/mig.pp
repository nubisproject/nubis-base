# MiG needs this on RHEL for lsb_release
if $osfamily == 'redhat' {
  package {'redhat-lsb-core':
    ensure => 'latest'
  }
}

class {'mig':
  version => '20160715',
  build   => '0.a06734a'
}
