# == Class: archlinux_workstation::userapps
#
# Install optional user applications. (all ::userapps:: classes)
#
# === Actions
#
# Declare instances of all archlinux_workstation::userapps:: classes
#
class archlinux_workstation::userapps {

  # make sure we're on arch, otherwise fail
  if $::osfamily != 'Archlinux' {
    fail("${::operatingsystem} not supported")
  }

  class {'archlinux_workstation::userapps::googlechrome': }
  class {'archlinux_workstation::userapps::virtualbox': }
  class {'archlinux_workstation::userapps::emacs': }
  class {'archlinux_workstation::userapps::rsnapshot': }
  class {'archlinux_workstation::userapps::firefox': }

}
