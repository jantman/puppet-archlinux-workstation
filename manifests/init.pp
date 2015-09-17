# == Class: archlinux_workstation
#
# Main class for archlinux_workstation.
#
# See README.markdown for advanced usage.
#
# This class sets up your user and group, declares a Firewall
# rule to allow SSH access, and provides variables for other
# classes in the module.
#
# === Parameters
#
# * __username__ - (string) Your login username. Used to create
#   your account, add you to certain groups, etc. Default: undef.
#
# * __user_home__ - Path to $username's home directory. Used for
#   classes that put files in the user's home directory. Default: "/home/${username}".
#
class archlinux_workstation (
  $username    = undef,
  $user_home   = undef,
  $user_groups = ['sys'],
) {

  # make sure we're on arch, otherwise fail
  if $::osfamily != 'Archlinux' {
    fail("${::operatingsystem} not supported")
  }

  # default uses another param
  if ! $user_home {
    $real_user_home = "/home/${username}"
  } else {
    $real_user_home = $user_home
  }

  validate_re($username, '^.+$', 'Parameter username must be a string for class archlinux_workstation')
  validate_absolute_path($real_user_home)

  archlinux_workstation::user { $username:
    username => $username,
    homedir  => $real_user_home,
    groups   => $user_groups,
  }

}
