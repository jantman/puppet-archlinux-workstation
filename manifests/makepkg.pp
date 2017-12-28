#
# Sets up [makepkg](https://wiki.archlinux.org/index.php/Makepkg) configuration
# for Arch Linux (``/etc/makepkg.conf``) for system-optimized compiling and
# compiling in /tmp tmpfs, and configures systemd to create tmpfs compile
# directories on boot.
#
# @param make_flags additional flags to pass to make via ``makepkg.conf``.
#  Defaults to setting ``-j`` (number of available processors for parallelization)
#  to the system's number of processors.
#
class archlinux_workstation::makepkg (
  String $make_flags = "-j${facts['processors']['count']}",
){

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  # variable access
  include archlinux_workstation

  $makepkg_user = $::archlinux_workstation::username
  $makepkg_packager = $::archlinux_workstation::makepkg_packager

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
    content => "# managed by archlinux_workstation::makepkg puppet class
D /tmp/sources 0775 ${archlinux_workstation::username} wheel
D /tmp/makepkg 0775 ${archlinux_workstation::username} wheel
D /tmp/makepkglogs 0775 ${archlinux_workstation::username} wheel",
  }

}
