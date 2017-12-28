#
# Install [DKMS](https://wiki.archlinux.org/index.php/Dynamic_Kernel_Module_Support)
#
class archlinux_workstation::dkms {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'dkms':
    ensure => present,
  }

}
