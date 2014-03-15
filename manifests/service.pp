# == Class archlinux_workstation::service
#
# This class is meant to be called from archlinux_workstation
# It ensure the service is running
#
class archlinux_workstation::service {

  service { $archlinux_workstation::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
