package { 'jq':
  ensure => hiera('jq_package_version', 'installed')
}
