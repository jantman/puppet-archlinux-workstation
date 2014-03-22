# == Class: archlinux_workstation::kde
#
# Perform a full installation of [KDE](https://wiki.archlinux.org/index.php/KDE) via the "kde" package group.
#
# === Actions:
#   - install "kde" package group
#
class archlinux_workstation::kde {

  # this is really a package group not a package
  package {'kde':
    ensure => present,
  }

}
