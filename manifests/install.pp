# == Class archlinux-workstation::install
#
class archlinux-workstation::install {

  package { $archlinux-workstation::package_name:
    ensure => present,
  }
}
