# Create default user as 'nubis'

if $::packer_builder_type != 'docker' {
  # Let cloud-init do it for us
  file { '/etc/cloud/cloud.cfg.d/default-user.cfg':
    ensure  => 'present',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => @(EOF)
'system_info':
  'default_user':
    'name': nubis
EOF
  }
}
else {
  group { 'nubis':
    ensure => 'present',
    gid    => '404',
  }

  user { 'nubis':
    ensure  => 'present',
    uid     => '404',
    gid     => '404',
    home    => '/home/nubis',
    shell   => '/bin/bash',
    require => [
      Group['nubis'],
    ],
  }
}

