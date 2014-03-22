# == Class: archlinux_workstation::swapfile
#
# Creates a swap file, makes swap, activates it and adds it to fstab
#
# This class uses some execs to create the swapfile, then execs swapon
# and uses Augeas to add the swapfile to /etc/fstab.
#
# === Parameters
#
# * __swapfile_path__ - (string) path where the swapfile will be stored.
#   Default: '/swapfile'. Must be an absolute path.
#
# * __swapfile_size__ - (string) size of the swapfile, in format allowed by fallocate,
#   i.e. a bare integer number of bytes, or an integer followed by K, M, G, T and so on
#   for KiB, MiB, GiB, TiB, etc. Default: '4G'.
#
# === Size Calculation
#
# The [Partitioning](https://wiki.archlinux.org/index.php/Partitioning#Swap) section of the Arch Linux
# Installation Guide mentions not using a swap file or partition at all on machines with over 2G of
# physical memory (so, these days, everything including your phone). But if you're like me, you occasionally
# run some memory intensive tasks (and use a tmpfs as scratch space), so it can come in handy. Also, you need
# some swap space if you ever want to hibernate.
#
# The Arch wiki [Suspend and Hibernate](https://wiki.archlinux.org/index.php/Suspend_and_Hibernate#About_swap_partition.2Ffile_size)
# page provides some guidance on suspend-to-disk image sizes, specifically that the image size can be obtained
# by reading ``/sys/power/image_size``, which is set by default to 2/5 the size of available RAM.
#
# === Actions
#
#   - Exec fallocate to create the swapfile
#   - Set permissions on the file
#   - Exec mkswap on the file
#   - Exec swapon passing it the path to the file
#   - Use augeas to add the swapfile to fstab
#
class archlinux_workstation::swapfile (
  $swapfile_path = '/swapfile',
  $swapfile_size = '4G'
) {

  validate_absolute_path($swapfile_path)
  validate_re($swapfile_size, '^[0-9]+[KMGTPEZY]?$')

  file { $swapfile_path:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec['fallocate-swap'],
  }

  exec { 'fallocate-swap':
    path    => '/usr/bin',
    command => "/usr/bin/fallocate -l ${swapfile_size} ${swapfile_path}",
    creates => $swapfile_path,
    notify  => Exec['mkswap-swapfile'],
  }

  exec { 'mkswap-swapfile':
    path        => '/usr/bin',
    command     => "/usr/bin/mkswap ${swapfile_path}",
    refreshonly => true,
    notify      => Exec['swapon-swapfile'],
  }

  exec { 'swapon-swapfile':
    path        => '/usr/bin',
    command     => "/usr/bin/swapon ${swapfile_path}",
    refreshonly => true,
  }

  augeas {'swapfile':
    context => '/files/etc/fstab',
    incl    => '/etc/fstab',
    lens    => 'fstab.lns',
    changes => [
      "set 01/spec '${swapfile_path}'",
      'set 01/file none',
      'set 01/vfstype swap',
      'set 01/opt defaults',
      'set 01/dump 0',
      'set 01/passno 0',
    ],
    onlyif  => "match *[spec='${swapfile_path}'] size == 0",
  }

}
