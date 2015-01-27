$jq_package_version = $osfamily ? {
  'RedHat' => '1.4-1.0.amzn1',
  'Debian' => '1.3-1.1ubuntu1',
}

package { 'jq':
  ensure => $jq_package_version
}
