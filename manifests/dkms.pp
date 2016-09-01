# Class: archlinux_workstation::dkms
#
# Install and run DKMS
#
# Parameters:
#
# Actions:
#   - Install dkms package
#   - Enable and run the dkms service
#
class archlinux_workstation::dkms {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'dkms':
    ensure => present,
  }

}
