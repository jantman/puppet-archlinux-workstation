#
# Install [rvm](https://rvm.io/) for the specified user, in their
# home directory.
#
# When RVM is installed, it specifies the option to *not* modify the user's
# shell rc scripts.
#
# @param user User to install rvm for.
# @param userhome Path to ``$user``'s home directory. Default: ``/home/${username}``.
#
define archlinux_workstation::userapps::rvm (
  String $user                     = $title,
  Variant[String, Undef] $userhome = undef,
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
