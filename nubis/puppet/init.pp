import 'packages.pp'

import 'apt.pp'
import 'confd.pp'
import 'consul.pp'
import 'fluentd.pp'
import 'jq.pp'
import 'postfix.pp'
import 'datadog.pp'
import 'mig.pp'
import 'user.pp'

# Simple node liveness check
include nubis_discovery
nubis::discovery::check { 'ping':
  check => "ping -c1 google.com",
  interval => "10s",
}
