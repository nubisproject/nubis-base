$node_exporter_version = "0.12.0rc3"
$node_exporter_url = "https://github.com/prometheus/node_exporter/releases/download/${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz"

notice ("Grabbing node_exporter ${node_exporter_version}")
staging::file { "node_exporter.${node_exporter_version}.tar.gz":
  source => $node_exporter_url,
}->
staging::extract { "node_exporter.${node_exporter_version}.tar.gz":
  target  => "/usr/local/bin",
  creates => "/usr/local/bin/node_exporter",
}

case $::osfamily {
  'RedHat': {
    file { '/etc/init.d/node_exporter':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///nubis/files/node_exporter.init',
    }->
    service { "node_exporter":
      enable => true,
    }
  }
  'Debian': {
    file { '/etc/init/node_exporter.conf':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///nubis/files/node_exporter.upstart',
    }
  }
}
