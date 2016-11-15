file { '/etc/nubis.d/01-gen-puppet.sh':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0755',
  source => 'puppet:///nubis/files/gen-puppet.sh',
}
