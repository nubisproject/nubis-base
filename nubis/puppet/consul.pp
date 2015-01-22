class { 'consul':
  version => "0.4.1",

  config_hash => {
      'data_dir'   	=> '/var/lib/consul',
      'log_level'  	=> 'INFO',
      'ui_dir'      	=> '/var/lib/consul/ui',
      'client_addr' 	=> '0.0.0.0',
      'server'      	=> false,
      'enable_syslog' 	=> true,
  }
}

# Need auto-join helper too, here for now, but needs to be merged into
# puppet somehow... Not sure it's worth merging upstream, however.
