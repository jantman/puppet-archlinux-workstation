# == Class: archlinux_workstation::kde
#
# Perform a full installation of [KDE](https://wiki.archlinux.org/index.php/KDE) via the "kde" package group.
#
# === Actions:
#   - install "kde" package group
#
class archlinux_workstation::kde {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  # this is really a package group not a package
  package {['plasma-meta', 'kde-applications-meta']:
    ensure => present,
  }

}
