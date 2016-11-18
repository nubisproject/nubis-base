$consul_cli_version  = '0.3.1'
$consul_cli_url      = "https://github.com/CiscoCloud/consul-cli/releases/download/v${consul_cli_version}/consul-cli_${consul_cli_version}_linux_amd64.tar.gz"

notice ("Grabbing consul-cli ${consul_cli_version}")
staging::file { "consul-cli.${consul_cli_version}.tar.gz":
  source => $consul_cli_url,
}

staging::extract { "consul-cli.${consul_cli_version}.tar.gz":
  target  => '/usr/local/bin',
  creates => '/usr/local/bin/consul-cli',
  strip   => '1',
  require => Staging::File["consul-cli.${consul_cli_version}.tar.gz"],
}
