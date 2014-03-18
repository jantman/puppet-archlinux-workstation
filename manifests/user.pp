# == Define: archlinux_workstation::user
#
# Manage a single real user on the system (i.e. a login user).
#
# === Parameters
#
# * __username__ - (string) The user's username.
#   Defaults to the resource title.
#
# * __realname__ - (string) The user's real name, to be used
#   in the passwd comment/GECOS field.
#
# * __homedir__ - (string) Path to $username's home directory.
#   Will be created if it does not exist.
#
# * __shell__ - (string) the user's login shell.
#   Default: '/bin/bash'
#
# * __groups__ - (array) list of supplementary groups that
#   this user should be a member of. Default: [].
#
# === Actions
#
# * ensure the user exists with an instance of the built-in User type
#
define archlinux_workstation::user (
  $username        = $title,
  $realname        = $title,
  $homedir         = "/home/${username}",
  $shell           = '/bin/bash',
  $groups          = undef,
) {

  user { $username:
    ensure     => present,
    name       => $username,
    comment    => $realname,
    gid        => $username,
    home       => $homedir,
    managehome => true,
    shell      => $shell,
  }

  if $groups {
    User[$username] {
      #require => [Group[$username], Group[$groups], ],
      require => [Group[$username], Group['one'], ],
    }
  } else {
    User[$username] {
      require => Group[$username],
    }
  }

  group { $username:
    ensure => present,
    name   => $username,
    system => false,
  }

}
