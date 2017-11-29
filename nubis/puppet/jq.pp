$jq_version = '1.5'

package { 'jq':
  ensure => "${jq_version}*",
}
