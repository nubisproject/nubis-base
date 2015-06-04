forge "https://forgeapi.puppetlabs.com"

####################### NOTE #############################
# All modules *must* be pinned to a specific version/tag #
##########################################################

# modules from the puppet forge
mod 'puppetlabs/stdlib', '4.5.1'
mod 'puppetlabs/mysql', '3.3.0'

# concat is required by apache as ">= 1.1.1 < 2.0.0" however the most
#+ current (1.2.1) has an unset reference to $backup. I am pinning here
#+ at 1.2.0 as this fixes the build. (2015-04-16). The concat module has
#+ been completly restructured to use electrical/file_concat, however
#+ we are currently unable to use the master branch of the concat module
#+ as it violates the apache concat require_version. Once a new tagged release
#+ of the concat module is released we should be able to remove this stanza.
mod 'puppetlabs/concat', '1.2.0'

# Get directly from github until apache::mod::remoteip is on puppetforge
#mod 'puppetlabs/apache', '1.4.0'
mod 'puppetlabs/apache',
    :git => 'https://github.com/puppetlabs/puppetlabs-apache',
    :ref => '28a53911fa215623ad142abf72ee63d618fce7bb'

mod 'puppetlabs/rabbitmq', '5.1.0'
mod 'puppetlabs/vcsrepo', '1.2.0'
mod 'jfryman/nginx', '0.2.6'

# Jenkins Dependencies
mod 'puppetlabs/apt', '1.8.0'
mod 'puppetlabs/java','1.3.0'
mod 'darin/zypprepo', '1.0.2'

# Jenkins itself
mod 'rtyler/jenkins', '1.3.0'

mod 'ajcrowe/supervisord', '0.5.2'
mod 'torrancew/cron', '0.1.0'
mod 'jbeard/nfs', '0.1.9'

mod 'stankevich/python', '1.9.1'

mod 'KyleAnderson/consul', '1.0.0'

mod 'ajcrowe/confd', '0.2.2'

# Skeleton to get above confd happy
mod 'nubis-confd_site',
    :git => 'https://github.com/gozer/nubis-site_confd.git'

mod 'srf/fluentd', '0.1.4'
mod 'mjhas/postfix', '1.0.0'

#mod 'lex/dnsmasq','2.6.1'
mod 'bhourigan/dnsmasq',
    :git => 'https://github.com/bhourigan/puppet-dnsmasq.git'

mod 'datadog/datadog_agent', '1.2.0'

mod 'nubis/nubis_discovery',
    :git => 'https://github.com/gozer/nubis-puppet-discovery.git'

mod 'nubis/nubis_configuration',
    :git => 'https://github.com/gozer/nubis-puppet-configuration.git'

mod 'nubis/nubis_storage',
    :git => 'https://github.com/Nubisproject/nubis-puppet-storage.git'

# This developer doesn't tag his releases on github
# https://github.com/maxchk/puppet-varnish/pull/57
# https://github.com/maxchk/puppet-varnish/pull/60
# https://github.com/maxchk/puppet-varnish/pull/61
mod 'maxchk/varnish',
    :git => 'https://github.com/gozer/puppet-varnish.git',
    :ref => 'nubis'

mod 'puppetlabs/firewall', '1.5.0'
mod 'thias/sysctl', '1.0.2'

mod 'maestrodev/wget', '1.7.0'
