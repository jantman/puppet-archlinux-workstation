# == Class: archlinux_workstation::userapps::geppetto
#
# Installs the [Geppetto](http://docs.puppetlabs.com/geppetto/latest/index.html) Eclipse-based
# Puppet IDE, via AUR package, and [puppet-lint](http://puppet-lint.com/) via gem.
#
# Actions:
#   - Install geppetto package
#
class archlinux_workstation::userapps::geppetto {

  package {'geppetto':
    ensure => present,
  }

  package {'puppet-lint':
    ensure   => present,
    provider => gem,
  }

}
