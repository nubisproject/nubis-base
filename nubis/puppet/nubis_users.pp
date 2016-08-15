file { '/etc/puppet/yaml':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
}

file { '/etc/puppet/hiera.yaml':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///nubis/files/hiera.yaml',
}

file { '/etc/confd/conf.d/nubis-users.toml':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///nubis/files/nubis_users/nubis-users.toml',
}

file { '/etc/confd/templates/nubis-users.toml':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///nubis/files/nubis_users/nubis-users.tmpl',
}
