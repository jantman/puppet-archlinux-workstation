# == Class: archlinux_workstation::userapps::emacs
#
# Install emacs-nox
#
# === Actions:
#   - Install emacs-nox
#
class archlinux_workstation::userapps::emacs {

  package {'emacs-nox':
    ensure  => present,
  }

}
