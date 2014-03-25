# Class: archlinux_workstation::base_packages
#
# Collection of base packages that we want installed on every system.
#
# Actions:
#   - ensure Package lynx is absent
#   - ensure Packages are present: links, lsb-release, dmidecode, ttf-dejavu,
#     vim, wget, dnsutils, net-tools, lsof, screen
#
class archlinux_workstation::base_packages {
  package {'links': ensure => present, }
  package {'lynx': ensure => absent, }
  package {'lsb-release': ensure => present, }
  package {'dmidecode': ensure => present, }
  package {'vim': ensure => present, }
  package {'ttf-dejavu': ensure => present, }
  package {'wget': ensure => present, }
  package {'dnsutils': ensure => present, }
  package {'net-tools': ensure => present, }
  package {'lsof': ensure => present, }
  package {'screen': ensure => present, }
}
