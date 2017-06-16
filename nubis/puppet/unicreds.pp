$unicreds_version = '1.5.1'
$unicreds_url = "https://github.com/Versent/unicreds/releases/download/${unicreds_version}/unicreds_${unicreds_version}_linux_amd64.tar.gz"

notice ("Grabbing unicreds ${unicreds_version}")
staging::file { "unicreds.${unicreds_version}.tar.gz":
  source => $unicreds_url,
}
->staging::extract { "unicreds.${unicreds_version}.tar.gz":
  target  => '/usr/local/bin',
  creates => '/usr/local/bin/unicreds',
}
