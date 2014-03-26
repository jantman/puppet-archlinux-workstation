# == Class: archlinux_workstation::userapps::irssi
#
# Install irssi
#
# === Actions:
#   - Install irssi
#
class archlinux_workstation::userapps::irssi {

  package {'irssi':
    ensure  => present,
  }

}
