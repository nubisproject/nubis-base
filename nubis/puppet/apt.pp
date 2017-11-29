if $osfamily == 'Debian' {
  class { 'apt':
  }
  # disable automatic upgrades
  package {'unattended-upgrades':
    ensure => 'absent',
  }
}
