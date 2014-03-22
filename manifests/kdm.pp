# Class: archlinux_workstation::kdm
#
# Install and run KDM, the KDE login manager.
#
# Parameters:
#
# Actions:
#   - Install kdebase-workspace package
#   - Enable the kdm service
#
class archlinux_workstation::kdm {

  package {'kdebase-workspace':
    ensure => present,
  }

  service {'kdm':
    enable => true,
  }

}
