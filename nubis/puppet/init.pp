import 'apt.pp'
import 'confd.pp'
import 'consul.pp'
import 'fluentd.pp'
import 'jq.pp'
import 'packages.pp'
import 'postfix.pp'
import 'datadog.pp'

file { '/etc/nubis-release':
      ensure  => 'present',
      content => "${project_name} ${project_version}\n"
}

# Simple node liveness check
include nubis_discovery
nubis::discovery::check { 'ping':
  check => "ping -c1 google.com",
  interval => "10s",
}
