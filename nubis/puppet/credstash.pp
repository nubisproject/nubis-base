# Unfortunately, we need to manage python in a somewhat manual way,
# since Amazon Linux ain't quite RedHat and that confuses our python
# puppet module.

#class { 'python':
#  version    => 'system',
#  pip        => true,
#  dev        => true,
#}

$pythondev = $::osfamily ? {
    'RedHat' => "python27-devel",
    'Debian' => "python-dev"
}

$pythonpip = $::osfamily ? {
    'RedHat' => "python27-pip",
    'Debian' => "python-pip"
}

package { $pythondev:
  ensure => present
}

package { $pythonpip:
  ensure => present
}
python::pip { 'credstash' :
    ensure        => '1.8'
}

file { '/usr/local/bin/nubis-secret':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => 'puppet:///nubis/files/nubis-secret',
    require => Python::Pip['credstash']
}
