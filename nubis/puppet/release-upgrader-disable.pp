# Disable Ubuntu's release upgrades checks

if $lsbdistid == 'Ubuntu' {
   package {'ubuntu-release-upgrader-core':
    ensure => 'absent',
  }
}
