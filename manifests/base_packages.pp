#
# Collection of base packages that we want installed on every system, and some
# packages to never be installed. See source for current package lists.
#
class archlinux_workstation::base_packages {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  $packages_absent = [
                      'lynx',
                      ]

  $packages_present = [
                      'bind',
                      'dialog',
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
