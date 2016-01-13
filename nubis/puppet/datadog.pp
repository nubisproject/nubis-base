class { 'datadog_agent':
    api_key => "%%DATADOG_API_KEY%%",
}

include 'datadog_agent::integrations::process'


include nubis_discovery
nubis::discovery::service { 'datadog':
  tags => [ 'datadog' ],
  check => "/usr/bin/curl -s -X GET -I http://localhost:17123/status",
  interval => "60s",
}

file { '/usr/local/bin/datadog-discover':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///nubis/files/datadog-discover',
}

include nubis_configuration
nubis::configuration{ 'datadog':
  prefix  => "/environments/%%ENVIRONMENT%%/global/datadog",
  format  => "sh",
  reload  => "/usr/local/bin/datadog-discover",
  require => File['/usr/local/bin/datadog-discover'],
}
