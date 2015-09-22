# == Class: archlinux_workstation::makepkg
#
# makepkg configuration for Arch Linux.
#
# - Setup /etc/makepkg.conf for system-optimized compiling and compiling in /tmp tmpfs
# - systemd to create tmpfs compile dirs on boot
#
# === Parameters
#
# * __make_flags__ - (string) additional flags to pass to make via makepkg.conf
#  default: "-j${::processorcount}"
#
class archlinux_workstation::makepkg (
  $make_flags = "-j${::processorcount}",
){

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  # variable access
  include archlinux_workstation

  $makepkg_user = $::archlinux_workstation::username

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
    owner  => $archlinux_workstation::username,
    group  => 'wheel',
    mode   => '0775',
  }

  file {'/tmp/makepkg':
    ensure => directory,
    owner  => $archlinux_workstation::username,
    group  => 'wheel',
    mode   => '0775',
  }

  file {'/tmp/makepkglogs':
    ensure => directory,
    owner  => $archlinux_workstation::username,
    group  => 'wheel',
    mode   => '0775',
  }

  file {'/etc/tmpfiles.d/makepkg_puppet.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "# managed by archlinux_workstation::makepkg puppet class\nD /tmp/sources 0775 ${archlinux_workstation::username} wheel\nD /tmp/makepkg 0775 ${archlinux_workstation::username} wheel\nD /tmp/makepkglogs 0775 ${archlinux_workstation::username} wheel",
  }

}
