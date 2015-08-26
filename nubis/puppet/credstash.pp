# Unfortunately, we need to manage python in a somewhat manual way,
# since Amazon Linux ain't quite RedHat and that confuses our python
# puppet module.

#class { 'python':
#  version    => 'system',
#  pip        => true,
#  dev        => true,
#}

$pythondev = $::osfamily ? {
    'RedHat' => $::osname ? {
       'Amazon' => "python27-devel",
       default  => "python-devel",
     },
    'Debian' => "python-dev"
}

$pythonpip = $::osfamily ? {
    'RedHat' => $::osname ? {
       'Amazon' => "python27-pip",
       default  => "python-pip",
    },
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
