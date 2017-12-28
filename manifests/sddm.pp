#
# Install and run [SDDM](https://wiki.archlinux.org/index.php/SDDM),
# the Simple Desktop Display Manager.
#
# @param service_ensure what state to ensure the SDDM service in. This is mainly
#  useful for acceptance testing the module or building system images.
class archlinux_workstation::sddm(
  Enum['stopped', 'running'] $service_ensure = running,
) {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'sddm':
    ensure => present,
  }

  service {'sddm':
    ensure => $service_ensure,
    enable => true,
  }

}
