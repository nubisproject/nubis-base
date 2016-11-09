file { '/usr/local/bin/gen-puppet.sh':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/gen-puppet.sh',
}

file { '/etc/nubis.d/99-gen-puppet.sh':
  ensure  => link,
  target  => '/usr/local/bin/gen-puppet.sh'
  require => File['/usr/local/bin/gen-puppet.sh'],
}

