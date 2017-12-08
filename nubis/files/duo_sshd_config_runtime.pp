# This manifest is used to disable publickey only authentication, this then
#+ requires both a publickey and DUO to log in.
#
# publickey is allowed during AMI build time as Packer is unable to use duo
#

notice("Running duo security SSH configuration")
augeas { 'Run Time Duo Security SSH Configuration' :
  changes => [
    'set /files/etc/ssh/sshd_config/AuthenticationMethods "publickey,keyboard-interactive"',
  ],
}
