# == Class: archlinux-workstation
#
# Full description of class archlinux-workstation here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class archlinux-workstation (
  $package_name = $archlinux-workstation::params::package_name,
  $service_name = $archlinux-workstation::params::service_name,
) inherits archlinux-workstation::params {

  # validate parameters here

  class { 'archlinux-workstation::install': } ->
  class { 'archlinux-workstation::config': } ~>
  class { 'archlinux-workstation::service': } ->
  Class['archlinux-workstation']
}
