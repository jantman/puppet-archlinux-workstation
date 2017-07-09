# == Define: archlinux_workstation::pacman_repo
#
# Manage a repository configured in /etc/pacman.conf.
#
# This manages repos in /etc/pacman.conf via puppetlabs/inifile.
#
# === Parameters
#
# * __repo_name__ - (string) The name of the repository.
#   Defaults to the resource title. For Pacman repos, this
#   string is _not_ user-configurable; it must match the name of
#   the database file in the repo.
#
# * __siglevel__ - (string) The signature verification level for this
#   repository; see the [pacman man page](https://www.archlinux.org/pacman/pacman.conf.5.html#SC)
#   for more information. The default is "Optional TrustedOnly".
#
# * __server__ - (string) URL to the pacman repository. Either this or include_file must be specified.
#
# *__include_file__ - (string) path to mirrorlist file to include. Either this or server must be specified.
# === Actions
#
# * ensure that a repository exists in /etc/pacman.conf with the specified settings
#
define archlinux_workstation::pacman_repo (
  $repo_name    = $title,
  $siglevel     = 'Optional TrustedOnly',
  $server       = undef,
  $include_file = undef,
) {

  if (! $server and ! $include_file) {
    fail("Either server or include_file must be specified on define archlinux_workstation::pacman_repo[${title}]")
  }

  if $server {
    validate_re($server, '^.+$', "Parameter server (URL) must be specified on define archlinux_workstation::pacman_repo[${title}]")

    ini_setting { "archlinux_workstation-pacman_repo-${title}-siglevel":
      ensure  => present,
      path    => '/etc/pacman.conf',
      section => $repo_name,
      setting => 'SigLevel',
      value   => $siglevel,
      notify  => Exec['pacman_repo-Sy'],
    }
    -> ini_setting { "archlinux_workstation-pacman_repo-${title}-server":
      ensure  => present,
      path    => '/etc/pacman.conf',
      section => $repo_name,
      setting => 'Server',
      value   => $server,
      notify  => Exec['pacman_repo-Sy'],
    }
  }

  if $include_file {
    validate_absolute_path($include_file)

    ini_setting { "archlinux_workstation-pacman_repo-${title}-include":
      ensure  => present,
      path    => '/etc/pacman.conf',
      section => $repo_name,
      setting => 'Include',
      value   => $include_file,
      notify  => Exec['pacman_repo-Sy'],
    }
  }

  if ! defined(Exec['pacman_repo-Sy']) {
    exec { 'pacman_repo-Sy':
      command     => '/usr/bin/pacman -Sy',
      refreshonly => true,
    }
  }
}
