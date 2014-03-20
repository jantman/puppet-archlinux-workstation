# == Class: archlinux_workstation
#
# Main class for archlinux_workstation.
#
# Assuming my configuration's defaults are suitable for you,
# declare this class, passing it the appropriate parameters.
#
# See README.markdown for advanced usage.
#
# This class *only* declares other classes in this module with
# appropriate parameters. For documentation on specific actions
# taken, see the other classes.
#
# === Parameters
#
# * __username__ - (string) Your login username. Used to create
#   your account, add you to certain groups, etc. Default: undef.
#   If left undefined, this module will not do anything to users
#   or groups, or anything that is user-specific.
#
# * __user_home__ - Path to $username's home directory. Used for
#   classes that put files in the user's home directory, and to
#   create SSH keys for the user. Default: "/home/${username}.
#   If set to undef, this module will not act on anything within
#   the user's home directory.
#
class archlinux_workstation (
  $username        = undef,
  $user_home       = "/home/${username}",
) inherits archlinux_workstation::params {

  # make sure we're on arch, otherwise fail
  if $::osfamily != 'Archlinux' {
    fail("${::operatingsystem} not supported")
  }

  # validate parameters here
  validate_absolute_path($user_home)

  # internal $userhome is undef if $username is undef
  if ! $username {
    $userhome = undef
  } else {
    $userhome = $user_home
    archlinux_workstation::user { $username:
      username => $username,
      homedir  => $userhome,
    }
  }

  # saz/sudo; this purges the current config
  class {'sudo': }

  sudo::conf {'defaults-env_keep':
    priority => 0,
    content  => 'Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET QTDIR KDEDIR XDG_SESSION_COOKIE"'
  }

  sudo::conf {'root-all':
    priority => 2,
    content  => 'root ALL=(ALL) ALL',
  }

  sudo::conf {"${username}-all":
    priority => 10,
    content  => "${username} ALL=(ALL) ALL",
  }

}
