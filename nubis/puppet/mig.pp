class mig (
  $version,
  $build
  )
{
 case $::osfamily {
    'redhat': {
      $ext = "rpm"
      $prod = "prod-1."
      $silly = "-"
      $provider = "rpm"
      $sep = "_"
    }
    'debian': {
      $ext = "deb"
      $prod = "prod_"
      $silly = "_"
      $provider = "dpkg"
      $sep = "-"
    }
    default: {
      fail("Unsupported OS Family:  ${osfamily}.")
    }
  }
    
   $url = "https://s3.amazonaws.com/mozopsecrepo2/mig-public/it-nubis/mig-agent${silly}${version}${sep}${build}.${prod}${::architecture}.${ext}"
   
   notice ("Grabbing from $url")
   
   wget::fetch { "download MIG $version $build":
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
  version => "20151105",
  build   => "0.a7466ac"
}
