# == Class: archlinux_workstation::yaourt
#
# Add the [archlinuxfr](http://archlinux.fr/yaourt-en) repo to pacman, install
# [yaourt](https://wiki.archlinux.org/index.php/Yaourt) so we can get packages from AUR.
# Also enable the [multilib](https://wiki.archlinux.org/index.php/Multilib) repository.
#
# === Actions:
#   - Add [archlinuxfr](http://archlinux.fr/yaourt-en) repository so we can install yaourt via pacman
#   - enable the [multilib](https://wiki.archlinux.org/index.php/Multilib) repository
#   - install the 'yaourt' Package
#
class archlinux_workstation::yaourt {

  ini_setting { 'pacman.conf-multilib':
    ensure  => present,
    path    => '/etc/pacman.conf',
    section => 'multilib',
    setting => 'Include',
    value   => '/etc/pacman.d/mirrorlist',
    notify  => Exec['pacman-resync'],
  }

  ini_setting { 'pacman.conf-archlinuxfr-siglevel':
    ensure  => present,
    path    => '/etc/pacman.conf',
    section => 'archlinuxfr',
    setting => 'SigLevel',
    value   => 'Never',
  }

  ini_setting { 'pacman.conf-archlinuxfr-server':
    ensure  => present,
    path    => '/etc/pacman.conf',
    section => 'archlinuxfr',
    setting => 'Server',
    value   => 'http://repo.archlinux.fr/$arch',
    notify  => Exec['pacman-resync'],
  }

  exec {'pacman-resync':
    refreshonly => true,
    user        => 'root',
    command     => '/usr/bin/pacman --noconfirm -Sy',
  }

  package {'yaourt':
    ensure  => present,
    require => [Ini_setting['pacman.conf-archlinuxfr-server'], Ini_setting['pacman.conf-archlinuxfr-siglevel'], Exec['pacman-resync']],
  }

}
