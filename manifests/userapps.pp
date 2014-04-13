# == Class: archlinux_workstation::userapps
#
# Install optional user applications. (all ::userapps:: classes)
#
# === Actions
#
# Declare instances of all archlinux_workstation::userapps:: classes
#
# === Parameters
#
# * __username__ - (string) Username for per-user apps.
#
# * __userhome__ - Path to $username's home directory. Used for
#   classes that put files in the user's home directory.
#   Default: "/home/${username}.
#
class archlinux_workstation::userapps (
  $username = undef,
  $userhome = undef,
) {

  # make sure we're on arch, otherwise fail
  if $::osfamily != 'Archlinux' {
    fail("${::operatingsystem} not supported")
  }

  class {'archlinux_workstation::userapps::googlechrome': }
  class {'archlinux_workstation::userapps::virtualbox': }
  class {'archlinux_workstation::userapps::emacs': }
  class {'archlinux_workstation::userapps::rsnapshot': }
  class {'archlinux_workstation::userapps::firefox': }
  class {'archlinux_workstation::userapps::mozilla_profilemanager': }
  class {'archlinux_workstation::userapps::irssi': }
  class {'archlinux_workstation::userapps::geppetto': }
  class {'archlinux_workstation::userapps::libreoffice': }

  archlinux_workstation::userapps::rvm { $username:
    userhome => $userhome,
  }

}
