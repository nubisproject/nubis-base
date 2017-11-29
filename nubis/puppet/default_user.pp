# Create default user as 'nubis'

if $::packer_builder_type != 'docker' {
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

