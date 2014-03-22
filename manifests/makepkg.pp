# == Class: archlinux_workstation::makepkg
#
# makepkg configuration for Arch Linux.
#
# - Setup /etc/makepkg.conf for system-optimized compiling and compiling in /tmp tmpfs
# - Setup systemd service and shell script to create tmpfs compile dir on boot
#
# === Parameters
#
# * __make_flags__ - (string) additional flags to pass to make via makepkg.conf
#  default: "-j${::processorcount}"
#
class archlinux_workstation::makepkg (
  $make_flags = "-j${::processorcount}",
){

  # base config files
  # Template Uses:
  # - $make_flags
  file {'/etc/makepkg.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('archlinux_workstation/makepkg.conf.erb'),
  }

  # these are needed for compiling packages under /tmp using makepkg
  file {'/tmp/sources':
    ensure => directory,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0775',
  }

  # the following ensures that /tmp/sources is created at boot, even if puppet isnt run
  file {'/usr/local/bin/maketmpdirs.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/archlinux_workstation/maketmpdirs.sh',
  }
  file {'/etc/systemd/system/maketmpdirs.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/archlinux_workstation/maketmpdirs.service',
    require => File['/usr/local/bin/maketmpdirs.sh'],
  }
  # this service runs at boot to create /tmp/sources
  service {'maketmpdirs':
    enable  => true,
    require => File['/etc/systemd/system/maketmpdirs.service'],
  }

}
