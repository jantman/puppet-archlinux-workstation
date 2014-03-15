# == Class archlinux_workstation::params
#
# This class is meant to be called from archlinux_workstation
# It sets variables according to platform
#
class archlinux_workstation::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'archlinux_workstation'
      $service_name = 'archlinux_workstation'
    }
    'RedHat', 'Amazon': {
      $package_name = 'archlinux_workstation'
      $service_name = 'archlinux_workstation'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
