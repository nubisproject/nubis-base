case $::osfamily {
  'RedHat': {
    $package_version = $::operatingsystemrelease ? {
      /^5/        => '1.10.1-0.el5',
      /^(6|2017)/ => '1.10.1-0.el6',
      /^7/        => '1.10.1-0.el7'
    }
  }
  'Debian': {
    $package_version = '1.10.1-0'
  }
  default: {
    fail("Module duo_unix does not support ${::osfamily}")
  }
}

class { 'duo_unix':
  usage           => 'pam',
  ikey            => 'XXXX',
  skey            => 'XXXX',
  host            => 'duo_host_not_configured',
  failmode        => 'safe',
  pushinfo        => 'yes',
  http_proxy      => 'proxy.service.consul:3128',
  send_gecos      => 'yes',
  package_version => $package_version
}

file { '/etc/duo/duo_sshd_config_runtime.pp':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
  source  => 'puppet:///nubis/files/duo_sshd_config_runtime.pp',
  require => Class['duo_unix'];
}

file { '/usr/local/bin/nubis-duo-reload':
  ensure  => file,
  owner   => root,
  group   => root,
  mode    => '0755',
  source  => 'puppet:///nubis/files/duo.sh',
  require =>  File['/etc/duo/duo_sshd_config_runtime.pp'],
}
