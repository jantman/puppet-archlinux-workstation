# == Class: archlinux_workstation::userapps::rvm
#
# Install [rvm](https://rvm.io/) for the specified user, in their
# home directory.
#
# When RVM is installed, it specifies the option to *not* modify the user's
# shell rc scripts.
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
  $userhome = undef,
) {

  if ! $userhome {
    $realhome = "/home/${user}"
  } else {
    $realhome = $userhome
  }

  # /etc/gemrc is put in place by the Pacman 'ruby' package, and sets
  # ``gem: --user-install``
  # "--user-install is used to install to $HOME/.gem/ by default since we want
  #   to separate pacman installed gems and gem installed gems"
  # this causes a problem with RVM, and also is unexpected behavior
  if ! defined(File['/etc/gemrc']) {
    file {'/etc/gemrc':
      ensure => absent,
    }
  }

  exec {"rvm-install-${user}":
    command     => 'curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles',
    creates     => "${realhome}/.rvm/bin/rvm",
    user        => $user,
    cwd         => $realhome,
    path        => '/usr/bin:/bin',
    environment => "HOME=${realhome}",
    require     => File['/etc/gemrc'],
  }

}
