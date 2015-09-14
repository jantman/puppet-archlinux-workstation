# == Class: archlinux_workstation::chrony
#
# Install and configure chrony, a roaming/laptop friendly NTP client,
# as well as the networkmanager-dispatcher-chrony script for it.
#
# === Parameters:
#
# * __chrony_password__ - The password that other clients will use to
#   connect to chrony. Our configuration only has chrony listening on
#   localhost/127.0.0.1, so this shouldn't be important.
#   Default: 'd83ja72.f83,8wHUW94'
#
# === Actions:
#   - Install chrony
#   - Install networkmanager-dispatcher-chrony for nm to tell chrony when we're on/offline
#   - Setup /etc/chrony.conf
#   - Setup /etc/chrony.keys with a static password
#   - Run the chrony service
#
class archlinux_workstation::chrony (
  $chrony_password = 'd83ja72.f83,8wHUW94',
) {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'chrony':
    ensure => present,
  }

  # nm hooks to tell chrony when we're on/offline
  package {'networkmanager-dispatcher-chrony':
    ensure => present,
  }

  file {'/etc/chrony.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/archlinux_workstation/chrony.conf',
    require => Package['chrony'],
    notify  => Service['chrony'],
  }

  file {'/etc/chrony.keys':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => "1 ${chrony_password}",
    require => Package['chrony'],
    notify  => Service['chrony'],
  }

  service {'chrony':
    ensure => running,
    enable => true,
  }

}
