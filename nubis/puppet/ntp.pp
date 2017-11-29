# Install and enable ntp with defaults

include '::ntp'

#RHEL7 defaults to chrony now, we don't want it
if $osfamily == 'RedHat' {
  package { 'chrony':
    ensure => absent
  }
}
