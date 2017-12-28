#
# Sets up [sudo](https://wiki.archlinux.org/index.php/Sudo), secure global
# defaults, and permissions for your user. This class wraps the
# [saz/sudo](https://forge.puppet.com/saz/sudo) module. If ``$::virtual == 'virtualbox'``,
# ``vagrant`` will also be given sudo permissions.
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

  if $::virtual == 'virtualbox' {
    notify {'adding vagrant to sudoers users, per $::virtual fact': }
    sudo::conf {'vagrant-all':
      priority => 11,
      content  => 'vagrant ALL=(ALL) NOPASSWD: ALL',
    }
  }

}
