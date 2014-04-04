# == Class: archlinux_workstation::userapps::rvm
#
# Install [rvm](https://rvm.io/) for the specified user, in their
# home directory.
#
# This specifies the option to _not_ modify the user's shell rc scripts.
#
# === Actions:
#   - Install rvm
#
# === Parameters
#
# * __username__ - (string) User to install rvm for.
#
# * __userhome__ - Path to $username's home directory. Default: "/home/${username}.
#
define archlinux_workstation::userapps::rvm (
  $user = $title,
  $userhome = "/home/${user}",
) {

  exec {"rvm-install-${user}":
    command => "curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles",
    creates => "${userhome}/.rvm",
    user    => $user,
    cwd     => $userhome,
    path    => '/usr/bin:/bin',
  }

}
