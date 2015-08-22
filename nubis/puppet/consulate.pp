# This all seems very magical but since package {'python': } is already declared in
# credstash.pp we don't have to worry about all that logic
#
# TODO: we should probably cleanup portions of the credstash.pp code and move it to init.pp

python::pip { 'consulate':
    ensure => '0.6.0',
    name   => 'consulate'
}
