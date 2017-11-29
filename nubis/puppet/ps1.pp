file {
    '/etc/profile.d/ps1.sh':
        ensure => present,
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///nubis/files/profile.d_ps1.sh',
}

# Disable Ubuntu's .bashrc PS1 overriding
if $lsbdistid == 'Ubuntu' {

  file {'/etc/skel/.bashrc':
    ensure => 'present',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///nubis/files/ubuntu-bashrc',
  }

  group { 'ubuntu':
    ensure => 'present',
    gid    => 1000,
  }

  user { 'ubuntu':
    ensure     => 'present',
    managehome => true,
    uid        => 1000,
    gid        => 1000,
    require    => [
      Group['ubuntu'],
    ],
  }

  file {'/home/ubuntu/.bashrc':
    ensure  => 'present',
    mode    => '0644',
    owner   => 'ubuntu',
    group   => 'ubuntu',
    require => [
      User['ubuntu'],
    ],
    source  => 'puppet:///nubis/files/ubuntu-bashrc',
  }
}

