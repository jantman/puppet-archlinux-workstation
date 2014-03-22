# == Class: archlinux_workstation::alsa
#
# Install alsa-utils package, and do initial unmute of the master channel.
#
# === Actions:
#   - Install alsa-utils package
#   - on initial install, unmute the Master channel to make sound work
#
class archlinux_workstation::alsa {

  package {'alsa-utils':
    ensure => present,
    notify => Exec['alsa-unmute-master'],
  }

  exec {'alsa-unmute-master':
    refreshonly => true,
    user        => 'root',
    command     => '/usr/bin/amixer sset Master unmute',
    require     => Package['alsa-utils'],
  }

}
