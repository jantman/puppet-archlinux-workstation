# == Class: archlinux_workstation::userapps::googlechrome
#
# Install proprietary google-chrome package and ttf-google-fonts-git from archlinuxfr repository.
#
# === Actions:
#   - Install google-chrome
#   - Install ttf-google-fonts-git
#
class archlinux_workstation::userapps::googlechrome {

  package {'google-chrome':
    ensure  => present,
    require => Class['archlinux_workstation::yaourt'],
  }

  package {'ttf-google-fonts-git':
    ensure  => present,
    require => Class['archlinux_workstation::yaourt'],
  }

}
