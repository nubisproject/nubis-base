class mig (
  $version
  )
{
 case $::osfamily {
    'redhat': {
      $ext = "rpm"
      $prod = "prod-1."
      $silly = "-"
      $provider = "rpm"
    }
    'debian': {
      $ext = "deb"
      $prod = "prod_"
      $silly = "_"
      $provider = "dpkg"
    }
    default: {
      fail("Unsupported OS Family:  ${osfamily}.")
    }
  }
    
   $url = "https://s3.amazonaws.com/mig-packages/mig-agent-nubis${silly}${version}.${prod}${::architecture}.${ext}"
   
   notice ("Grabbing from $url")
   
   wget::fetch { "download MIG $version":
      source => $url,
      destination => "/tmp/mig.$ext",
      verbose => true,
      redownload => true, # The file already exists, we replace it
  }->
  package { 'mig':
    source => "/tmp/mig.$ext",
    ensure => "present",
    provider => $provider,
  }

}

class {'mig':
  version => "20150522%2B9ec761b"
}
