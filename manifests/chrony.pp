#
# Install and configure [Chrony](https://wiki.archlinux.org/index.php/Chrony),
# a roaming/laptop friendly NTP client, as well as the
# [networkmanager-dispatcher-chrony](https://aur.archlinux.org/packages/networkmanager-dispatcher-chrony/)
# script for it.
#
# @param chrony_password The password that other clients will use to
#   connect to chrony. Our configuration only has chrony listening on
#   localhost/127.0.0.1, so this shouldn't be important.
#
class archlinux_workstation::chrony (
  String $chrony_password = 'd83ja72.f83,8wHUW94',
) {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'chrony':
    ensure => present,
  }

  # nm hooks to tell chrony when we're on/offline
  # this is an AUR package, which is in my repo
  package {'networkmanager-dispatcher-chrony':
    ensure  => present,
    require => Class['archlinux_workstation::repos::jantman'],
  }

  file {'/etc/chrony.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/archlinux_workstation/chrony.conf',
    require => Package['chrony'],
    notify  => Service['chronyd'],
  }

  file {'/etc/chrony.keys':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => "1 ${chrony_password}",
    require => Package['chrony'],
    notify  => Service['chronyd'],
  }

  service {'chronyd':
    ensure => running,
    enable => true,
  }

}
