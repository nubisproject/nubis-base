import "apt.pp"
import "confd.pp"
import "consul.pp"
import "dnsmasq.pp"
import "fluentd.pp"
import "jq.pp"
import "packages.pp"
import "postfix.pp"

file { "/etc/nubis-release":
  ensure => "present",
  content => "nubis-base ${nubis_relase}.${nubis_build}\n"
}
