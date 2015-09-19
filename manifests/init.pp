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
# * __realname__ - (string) The user's real name, to be used
#   in the passwd comment/GECOS field. Defaults to $username if not specified.
#
# * __user_home__ - Path to $username's home directory. Used for
#   classes that put files in the user's home directory. Default: "/home/${username}".
#
# * __shell__ - (string) the user's login shell.
#   Default: '/bin/bash'
#
# * __user_groups__ - (array) list of supplementary groups that
#   this user should be a member of. Default: ['sys']
#
class archlinux_workstation (
  $username    = undef,
  $realname    = undef,
  $user_home   = undef,
  $shell       = '/bin/bash',
  $user_groups = ['sys'],
) {

  # make sure we're on arch, otherwise fail
  if $::osfamily != 'Archlinux' {
    fail("${::operatingsystem} not supported")
  }

  # user_home - default uses another param
  if ! $user_home {
    $real_user_home = "/home/${username}"
  } else {
    $real_user_home = $user_home
  }

  # realname - default uses another param
  if $realname {
    $real_name = $realname
  } else {
    $real_name = $username
  }

  validate_re($username, '^.+$', 'Parameter username must be a string for class archlinux_workstation')
  validate_absolute_path($real_user_home)

  # we make the user a virtual resource and then realize it so that other
  # classes can append to the 'groups' attribute using plusignment
  @user { $username:
    ensure     => present,
    name       => $username,
    comment    => $real_name,
    gid        => $username,
    home       => $real_user_home,
    managehome => true,
    shell      => $shell,
    groups     => $user_groups,
    require    => Group[$username],
  }

  User <| title == $username |>

  group { $username:
    ensure => present,
    name   => $username,
    system => false,
  }

}
