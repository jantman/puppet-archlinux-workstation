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

  package {'dkms':
    ensure => present,
  }

  service {'dkms':
    ensure => running,
    enable => true,
  }

}
