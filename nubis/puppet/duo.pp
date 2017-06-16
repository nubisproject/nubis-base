case $::operatingsystem {
  'Amazon': {
    $package_version = '1.9.21-0.el6'
  }
  'CentOS': {
    $package_version = '1.9.21-0.el7'
  }
  'Ubuntu': {
    $package_version = '1.9.21-0'
  }
  default: {
    fail("Module duo_unix does not support ${::operatingsystem}")
  }
}

class { 'duo_unix':
  usage      => 'pam',
  ikey       => 'XXXX',
  skey       => 'XXXX',
  host       => 'duo_host_not_configured',
  failmode   => 'safe',
  pushinfo   => 'yes',
  http_proxy => 'proxy.service.consul:3128',
  send_gecos => 'yes',
  package_version => "$package_version"
}
