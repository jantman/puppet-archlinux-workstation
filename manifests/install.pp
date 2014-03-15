# == Class archlinux_workstation::install
#
class archlinux_workstation::install {

  package { $archlinux_workstation::package_name:
    ensure => present,
  }
}
