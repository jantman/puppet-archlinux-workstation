# == Class: archlinux_workstation::networkmanager
#
# Install and setup networkmanager its GUI components, and ensure dhcpcd is stopped and nm is running.
#
# === Parameters:
#
# * __gui__ - the $gui value from archlinux_workstation. See that class for docs.
#
# === Actions:
#   - Install networkmanager
#   - if archlinux_workstation::kde is defined, install kdeplasma-applets-networkmanagement
#   - Ensure NetworkManager service is running and enabled
#   - Ensure dhcpcd service is stopped and disabled
#
class archlinux_workstation::networkmanager {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'networkmanager':
    ensure => present,
  }

  if defined(Class['archlinux_workstation::kde']) {
    package {'kdeplasma-applets-networkmanagement':
      ensure  => present,
      require => Package['networkmanager'],
    }
  }

  service {'NetworkManager':
    ensure  => running,
    enable  => true,
    require => Package['networkmanager'],
  }

  service {'dhcpcd':
    ensure  => stopped,
    enable  => false,
    require => Service['NetworkManager'],
  }

}
