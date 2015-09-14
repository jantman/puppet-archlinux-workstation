# == Class: archlinux_workstation::cronie
#
# Install and run the [cronie](https://fedorahosted.org/cronie/) cron daemon.
# Per the [Arch wiki cron entry](https://wiki.archlinux.org/index.php/cron),
# no cron daemon comes default with Arch.
#
# === Parameters:
#
# === Actions:
#   - Install cronie
#   - Run the cronie service
#
class archlinux_workstation::cronie {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'cronie':
    ensure => present,
  }

  service {'cronie':
    ensure => running,
    enable => true,
  }

}
