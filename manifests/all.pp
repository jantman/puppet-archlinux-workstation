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

  # ALL classes in archlinux_workstation module
  include archlinux_workstation::ssh

}
