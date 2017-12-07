# Silence this warning:

# Warning: The package type's allow_virtual parameter will be changing its default value from
# false to true in a future release. If you do not want to allow virtual packages, please
# explicitly set allow_virtual to false.

Package {
  allow_virtual => false,
}

# we don't want no vim-minimal
if $osfamily == 'RedHat' {
  package { 'vim-enhanced':
    ensure =>  present,
  }
}
