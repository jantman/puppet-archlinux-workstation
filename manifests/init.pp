# == Class: archlinux_workstation
#
# Full description of class archlinux_workstation here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class archlinux_workstation (
  $package_name = $archlinux_workstation::params::package_name,
  $service_name = $archlinux_workstation::params::service_name,
) inherits archlinux_workstation::params {

  if $::osfamily != 'Archlinux' {
    fail("${::operatingsystem} not supported")
  }

  # validate parameters here

}
