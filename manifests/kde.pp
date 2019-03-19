#
# Perform a full installation of [KDE](https://wiki.archlinux.org/index.php/KDE)
# via the "kde" package group.
#
class archlinux_workstation::kde {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {['plasma-meta', 'kde-applications-meta']:
    ensure => present,
  }

  # phonon/vlc audio; we install both backends
  $phonon_packages = [
                      'phonon-qt5',
                      'phonon-qt5-gstreamer',
                      'phonon-qt5-vlc',
                      ]
  package { $phonon_packages:
    ensure => present,
  }
}
