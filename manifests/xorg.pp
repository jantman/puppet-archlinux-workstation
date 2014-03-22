# == Class: archlinux_workstation::xorg
#
# Install packages required for xorg X server, as well as some additional
# packages.
#
# === Actions:
#   - Install X server required packages xorg-server, xorg-server-utils,
#     xorg-xinit and mesa.
#   - Install xorg-apps package group
#
class archlinux_workstation::xorg {

  $xorg_packages = ['xorg-server',
                    'xorg-apps',
                    'xorg-server-utils',
                    'xorg-xinit',
                    'mesa',
                    'xf86-video-vesa']

  package {$xorg_packages:
    ensure => present,
  }

}
