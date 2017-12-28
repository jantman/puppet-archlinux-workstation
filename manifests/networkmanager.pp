#
# Install and setup [networkmanager](https://wiki.archlinux.org/index.php/NetworkManager),
# ensure dhcpcd is stopped and nm is running. If ``archlinux_workstation::kde`` is defined, also
# install ``kdeplasma-applets-networkmanagement``.
#
class archlinux_workstation::networkmanager {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'networkmanager':
    ensure => present,
  }

  if defined(Class['archlinux_workstation::kde']) {
    package {'plasma-nm':
      ensure  => present,
      require => Package['networkmanager'],
    }
  }

  service {'NetworkManager':
    ensure  => running,
    enable  => true,
    require => Package['networkmanager'],
  }

  $ifs = split($::interfaces, ',')

  $ifs.each |String $ifname| {
    service {"dhcpcd@${ifname}":
      ensure  => stopped,
      enable  => false,
      require => Service['NetworkManager'],
    }
  }

}
