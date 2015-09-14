# == Class: archlinux_workstation::sudo
#
# Sets up sudo, global defaults, and permissions for your user. This class
# simply wraps saz/sudo.
#
class archlinux_workstation::sudo {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  # variable access
  include archlinux_workstation

  # Class content here
  # saz/sudo; this purges the current config
  class {'sudo': }

  sudo::conf {'defaults-env_keep':
    priority => 0,
    content  => 'Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET QTDIR KDEDIR XDG_SESSION_COOKIE"'
  }

  sudo::conf {"${archlinux_workstation::username}-all":
    priority => 10,
    content  => "${archlinux_workstation::username} ALL=(ALL) ALL",
  }

}
