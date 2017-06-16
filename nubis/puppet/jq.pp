$jq_version = '1.5'
$jq_url = "https://github.com/stedolan/jq/releases/download/jq-${jq_version}/jq-linux64"

# XXX: We require a recent jq, not in repos yet
notice ("Grabbing jq ${jq_version}")

staging::file { '/usr/local/bin/jq':
  source => $jq_url,
  target => '/usr/local/bin/jq',
}
->exec { 'chmod /usr/local/bin/jq':
  command => 'chmod 755 /usr/local/bin/jq',
  path    => ['/sbin','/bin','/usr/sbin','/usr/bin','/usr/local/sbin','/usr/local/bin'],
}
->file { '/usr/bin/jq':
  ensure => 'link',
  target => '/usr/local/bin/jq',
}
