# == Class: archlinux_workstation
#
# Main class for archlinux_workstation.
#
# Assuming my configuration's defaults are suitable for you,
# declare this class, passing it the appropriate parameters.
#
# See README.markdown for advanced usage.
#
# This class declares other classes in this module with
# appropriate parameters. For documentation on specific actions
# taken, see the other classes.
#
# It also uses the following classes outside of this module:
#
# * [saz/sudo](https://github.com/saz/puppet-sudo) to manage sudoers
#   and sudoers.d entries for root and your user
# * [saz/ssh](http://forge.puppetlabs.com/saz/ssh) to configure sshd
#   server; access limited to $username only, pubkey/RSA
#
# === Parameters
#
# * __username__ - (string) Your login username. Used to create
#   your account, add you to certain groups, etc. Default: undef.
#   If left undefined, this module will not do anything to users
#   or groups, or anything that is user-specific.
#
# * __user_home__ - Path to $username's home directory. Used for
#   classes that put files in the user's home directory, and to
#   create SSH keys for the user. Default: "/home/${username}.
#   If set to undef, this module will not act on anything within
#   the user's home directory.
#
# * __swapfile_path__ - Path to create a swapfile at. Set to
#   undef to not create and use a swap file. Default: /swapfile.
#
# * __swapfile_size__ - If $swapfile_path is not undef, override
#   the default of this parameter in archlinux_workstation::swapfile.
#
# * __gui__ - Install a graphical/desktop environment. Currently
#   accepted values are "kde" or undef. Pull requests welcome for others.
#   X will be installed either way.
#
class archlinux_workstation (
  $username        = undef,
  $user_home       = "/home/${username}",
  $swapfile_path   = '/swapfile',
  $swapfile_size   = undef,
  $gui             = 'kde',
) inherits archlinux_workstation::params {

  # make sure we're on arch, otherwise fail
  if $::osfamily != 'Archlinux' {
    fail("${::operatingsystem} not supported")
  }

  # validate parameters here
  validate_absolute_path($user_home)
  if $gui != undef {
    validate_re($gui, '^(kde)$')
  }

  # internal $userhome is undef if $username is undef
  if ! $username {
    $userhome = undef
  } else {
    $userhome = $user_home
    archlinux_workstation::user { $username:
      username => $username,
      homedir  => $userhome,
    }
  }

  # saz/sudo; this purges the current config
  class {'sudo': }

  sudo::conf {'defaults-env_keep':
    priority => 0,
    content  => 'Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET QTDIR KDEDIR XDG_SESSION_COOKIE"'
  }

  sudo::conf {"${username}-all":
    priority => 10,
    content  => "${username} ALL=(ALL) ALL",
  }

  # saz/ssh
  class { 'ssh::server':
    storeconfigs_enabled => false,
    options              => {
      'AllowUsers'             => $username,
      'AuthorizedKeysFile'     => '.ssh/authorized_keys',
      'GSSAPIAuthentication'   => 'no',
      'KerberosAuthentication' => 'no',
      'PasswordAuthentication' => 'no',
      'PermitRootLogin'        => 'no',
      'Port'                   => [22],
      'PubkeyAuthentication'   => 'yes',
      'RSAAuthentication'      => 'yes',
      'SyslogFacility'         => 'AUTH',
      'UsePrivilegeSeparation' => 'sandbox', # "Default for new installations."
      'X11Forwarding'          => 'no',
    },
  }

  # firewall rule for ssh
  firewall { '005 allow ssh':
    port   => [22],
    proto  => tcp,
    action => accept,
  }

  class {'archlinux_workstation::makepkg': }
  class {'archlinux_workstation::base_packages': }
  class {'archlinux_workstation::dkms': }

  if $swapfile_path != undef {
    class {'archlinux_workstation::swapfile':
      swapfile_path => $swapfile_path,
      swapfile_size => $swapfile_size,
    }
  }

  class {'archlinux_workstation::yaourt': }
  class {'archlinux_workstation::cups': }

  if $gui == 'kde' {
    class {'archlinux_workstation::kde': }
  }

  class {'archlinux_workstation::networkmanager':
    gui => $gui,
  }

  class {'archlinux_workstation::chrony': }
  class {'archlinux_workstation::alsa': }

}
