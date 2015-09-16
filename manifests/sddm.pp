# Class: archlinux_workstation::sddm
#
# Install and run SDDM, the Simple Desktop Display Manager.
#
# Parameters:
#
# Actions:
#   - Install sddm package
#
class archlinux_workstation::sddm {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'sddm':
    ensure => present,
  }

  service {'sddm':
    ensure => running,
    enable => true,
  }

}
