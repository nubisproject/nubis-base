# This manifest is used to disable publickey only authentication, this then
#+ requires both a publickey and DUO to log in.
#
# publickey is allowed during AMI build time as Packer is unable to use duo
#

case $::osfamily {
  'RedHat': {
    $ssh_service = 'sshd'
  }
  'Debian': {
    $ssh_service = 'ssh'
  }
  default: {
    fail("Module duo_unix does not support ${::osfamily}")
  }
}

service { $ssh_service:
  ensure => running,
  enable => true;
}

augeas { 'Run Time Duo Security SSH Configuration' :
  changes => [
    'set /files/etc/ssh/sshd_config/AuthenticationMethods "publickey,keyboard-interactive"',
  ],
  notify  => Service[$ssh_service];
}
