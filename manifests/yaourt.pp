# == Class: archlinux_workstation::yaourt
#
# Add the [archlinuxfr](http://archlinux.fr/yaourt-en) repo to pacman, install
# [yaourt](https://wiki.archlinux.org/index.php/Yaourt) so we can get packages from AUR.
# Also enable the [multilib](https://wiki.archlinux.org/index.php/Multilib) repository.
#
# === Actions:
#   - Add [archlinuxfr](http://archlinux.fr/yaourt-en) repository so we can install yaourt via pacman
#   - run ``pacman --sync --refresh yaourt`` when the repo file changes
#   - enable the [multilib](https://wiki.archlinux.org/index.php/Multilib) repository
#
class archlinux_workstation::yaourt {

#  file { '/etc/pacman.conf':
#    ensure  => present,
#    owner   => 'root',
#    group   => 'root',
#    mode    => '0644',
#    source  => 'puppet:///modules/archlinux_workstation/pacman.conf',
#  }

  ini_setting { 'pacman.conf-multilib':
    ensure  => present,
    path    => '/tmp/pacman.conf',
    section => 'multilib',
    setting => 'Include',
    value   => '/etc/pacman.d/mirrorlist',
#    notify  => Exec['pacman_sync_yaourt'],
  }

#  exec {'pacman_sync_yaourt':
#    refreshonly => 'true',
#    user        => 'root',
#    command     => '/usr/bin/pacman --noconfirm --sync --refresh yaourt',
#    require     => File['/etc/pacman.d/archlinuxfr.conf'],
#  }

}
