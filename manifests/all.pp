# == Class: archlinux_workstation::all
#
# Include ALL other archlinux_workstation classes.
#
# WARNING - except on a brand new system, this is probably NOT
# what you want to do!
#
# See README.markdown for advanced usage.
#
class archlinux_workstation::all {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  # variable access
  include archlinux_workstation

  # repos
  include archlinux_workstation::repos::jantman

  # ALL classes in archlinux_workstation module
  include archlinux_workstation::base_packages
  include archlinux_workstation::chrony
  include archlinux_workstation::cronie
  include archlinux_workstation::cups
  include archlinux_workstation::dkms
  include archlinux_workstation::makepkg
  include archlinux_workstation::ssh
  include archlinux_workstation::sudo

  class {'archlinux_workstation::xorg': } ->
  class {'archlinux_workstation::kde': } ->
  class {'archlinux_workstation::sddm': } ->
  class {'archlinux_workstation::networkmanager': }

  # userapps
  archlinux_workstation::userapps::rvm { $archlinux_workstation::username : }
  include archlinux_workstation::userapps::virtualbox

}
