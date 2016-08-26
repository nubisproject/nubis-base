# PAM hook to invoke our utility on ssh logins and taint the instance
pam { "Set PAM sshd to taint resources":
  ensure    => present,
  service   => 'sshd',
  type      => 'session',
  control   => 'optional',
  module    => 'pam_exec.so',
  arguments => ["log=/var/log/tainted.log", "/usr/local/sbin/nubis-taint"],
}

# Wrapper to actually perform the tainting
file {"/usr/local/sbin/nubis-taint":
 ensure => file,
 owner  => root,
 group  => root,
 mode   => '0755',
 source => 'puppet:///nubis/files/nubis-taint',
}

# Util script to check if we are tainted
file {"/usr/local/bin/nubis-tainted":
 ensure => file,
 owner  => root,
 group  => root,
 mode   => '0755',
 source => 'puppet:///nubis/files/nubis-tainted',
}

# Utility to self-terminate tainted instance
file {"/usr/local/sbin/nubis-taint-reap":
 ensure => file,
 owner  => root,
 group  => root,
 mode   => '0755',
 source => 'puppet:///nubis/files/nubis-taint-reap',
}

# Warning on ssh login about taintedness
file {"/etc/ssh/sshrc":
 ensure => file,
 owner  => root,
 group  => root,
 mode   => '0755',
 source => 'puppet:///nubis/files/sshrc',
}

cron::hourly {
  'nubis-taint-reap':
    user        => 'root',
    command     => '/usr/local/sbin/nubis-taint-reap',
}

file { "/etc/consul/svc-tainted.json":
 ensure => file,
 owner  => root,
 group  => root,
 mode   => '0644',
 source => 'puppet:///nubis/files/svc-tainted.json',
 require => Class['consul'],
}
