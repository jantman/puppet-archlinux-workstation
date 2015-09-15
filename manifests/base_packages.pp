# Class: archlinux_workstation::base_packages
#
# Collection of base packages that we want installed on every system.
#
# Actions:
#   - ensure Packages are absent: lynx
#   - ensure Packages are present: links, lsb-release, dmidecode, ttf-dejavu,
#     vim, wget, bind-tools, net-tools, lsof, screen
#
class archlinux_workstation::base_packages {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  $packages_absent = [
                      'lynx',
                      ]

  $packages_present = [
                       'bind-tools',
                       'dmidecode',
                       'links',
                       'lsb-release',
                       'lsof',
                       'lsscsi',
                       'net-tools',
                       'screen',
                       'ttf-dejavu',
                       'vim',
                       'wget',
                       ]

  package {$packages_present : ensure => present, }
  package {$packages_absent : ensure => absent, }
}
