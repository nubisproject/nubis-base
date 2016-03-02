# Disable NFS related services

if $osfamily == 'RedHat' {
  service { 'rpcbind':
    enable => false,
    ensure => 'stopped',
  }
  service { 'nfslock':
    enable => false,
    ensure => 'stopped',
  }
}
