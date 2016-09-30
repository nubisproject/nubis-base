# Disable NFS related services

if $osfamily == 'RedHat' {
  service { 'rpcbind':
    ensure => 'stopped',
    enable => false,
  }
  service { 'nfslock':
    ensure => 'stopped',
    enable => false,
  }
}
