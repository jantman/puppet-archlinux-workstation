# == Class: archlinux_workstation::repos::jantman
#
# Sets up my personal pacman repo for some required packages.
#
class archlinux_workstation::repos::jantman {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  archlinux_workstation::pacman_repo { 'jantman':
    server => 'http://archrepo.jasonantman.com/current',
  }

}
