augeas { 'Disable SSH StrictHostKeyChecking':
  changes => [
    'set /files/etc/ssh/ssh_config/Host[*]/StrictHostKeyChecking "no"',
    'set /files/etc/ssh/ssh_config/Host[*]/UserKnownHostsFile "/dev/null"',
  ],
}
