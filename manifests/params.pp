# == Class archlinux-workstation::params
#
# This class is meant to be called from archlinux-workstation
# It sets variables according to platform
#
class archlinux-workstation::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'archlinux-workstation'
      $service_name = 'archlinux-workstation'
    }
    'RedHat', 'Amazon': {
      $package_name = 'archlinux-workstation'
      $service_name = 'archlinux-workstation'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
