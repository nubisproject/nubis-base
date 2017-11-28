if $osfamily == 'RedHat' {
  class { 'selinux':
    mode => 'disabled',
  }
}
