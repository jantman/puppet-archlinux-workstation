#
# Manage a repository configured in ``/etc/pacman.conf``.
#
# This manages repos in ``/etc/pacman.conf`` via the
# [puppetlabs/inifile](https://forge.puppet.com/puppetlabs/inifile) module.
#
# @param repo_name The name of the repository. For Pacman repos, this string is
#  __not__ user-configurable; it must match the name of the database file in the repo.
# @param siglevel The signature verification level for this repository; see the
#  [pacman man page](https://www.archlinux.org/pacman/pacman.conf.5.html#SC) for
#  more information.
# @param server URL to the pacman repository. Either this or include_file must be specified.
# @param include_file path to mirrorlist file to include. Either this or server must be specified.
#
define archlinux_workstation::pacman_repo (
  String $repo_name                    = $title,
  String $siglevel                     = 'Optional TrustedOnly',
  Variant[String, Undef] $server       = undef,
  Variant[String, Undef] $include_file = undef,
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
