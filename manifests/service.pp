# == Class archlinux-workstation::service
#
# This class is meant to be called from archlinux-workstation
# It ensure the service is running
#
class archlinux-workstation::service {

  service { $archlinux-workstation::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
