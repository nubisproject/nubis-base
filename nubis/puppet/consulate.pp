# Probably not the best idea since we are duplicating code here,
# perhaps a got spot to put this is in init.pp

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

python::pip { 'consulate':
    ensure => '0.6.0',
    name   => 'consulate'
}
