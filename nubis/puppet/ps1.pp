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

  file {'/home/ubuntu/.bashrc':
    ensure => 'present',
    mode   => '0644',
    owner  => 'ubuntu',
    group  => 'ubuntu',
    source => 'puppet:///nubis/files/ubuntu-bashrc',
  }
}

