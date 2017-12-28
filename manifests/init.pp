#
# Main class for archlinux_workstation.
#
# See {file:README.markdown README.markdown} for advanced usage.
#
# This class sets up your user and group and provides variables for other
# classes in the module.
#
# @param username Your login username. Used to create your account, add you to
#  certain groups, etc.
# @param realname The user's real name, to be used in the passwd comment/GECOS
#  field. Defaults to ``$username`` if not specified.
# @param user_home Path to ``$username``'s home directory. Used for classes that put
#  files in the user's home directory. Default: ``/home/${username}``.
# @param shell the user's login shell.
# @param user_groups list of supplementary groups that this user should be a member of.
# @param makepkg_packager String to set as PACKAGER in makepkg.conf
#   (see <https://wiki.archlinux.org/index.php/Makepkg#Packager_information>);
#   if left blank, PACKAGER will be omitted and built packages will default to
#   "Unknown Packager".
#
class archlinux_workstation (
  String $username                         = undef,
  String $realname                         = undef,
  Variant[String, Undef] $user_home        = undef,
  String $shell                            = '/bin/bash',
  Array[String] $user_groups               = ['sys'],
  Variant[String, Undev] $makepkg_packager = undef,
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
    require    => [ Group[$username] ],
  }

  User <| title == $username |>

  group { $username:
    ensure => present,
    name   => $username,
    system => false,
  }

}
