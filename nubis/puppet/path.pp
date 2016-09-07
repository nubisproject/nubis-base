# Only for amazon linux for now since they are the only ones silly enough to not
# export local paths
if $::operatingsystem == 'Amazon' {
  file { '/etc/profile.d/bash_path.sh':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0744',
    source => 'puppet:///nubis/files/profile.d_path.sh',
  }
}
