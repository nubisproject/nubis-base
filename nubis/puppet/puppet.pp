# Enabled by default by puppet-agent, disable
service { [ 'puppet', 'mcollective', 'pxp-agent' ]:
  ensure => 'stopped',
  enable => false,
}
