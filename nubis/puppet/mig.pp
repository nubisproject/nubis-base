# MiG needs this on RHEL for lsb_release
if $osfamily == 'redhat' {
  package {'redhat-lsb-core':
    ensure => 'latest'
  }
}

class {'mig':
  version => '20180803',
  build   => '0.e8eb90a'
}
