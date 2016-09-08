# Sudo module actually purges out config, this here tells it to not do that
# This basically leaves whatever is in /etc/sudoers and /etc/sudoers.d alone
class { 'sudo':
  purge               => false,
  config_file_replace => false,
}

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
    source => 'puppet:///nubis/files/nubis_users/hiera.yaml',
}

file { '/etc/puppet/yaml/nubis_users':
  ensure  => directory,
  owner   => root,
  group   => root,
  recurse => true,
  source  => 'puppet:///nubis/files/nubis_users/hiera',
}

file { '/etc/confd/conf.d/nubis-users.toml':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///nubis/files/nubis_users/nubis-users.toml',
}

file { '/etc/confd/templates/nubis-users.tmpl':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///nubis/files/nubis_users/nubis-users.tmpl',
}
