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
    ensure        => '1.5'
}
