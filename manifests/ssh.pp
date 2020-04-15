#
# Configure [SSH](https://wiki.archlinux.org/index.php/Secure_Shell) server via
# [saz/ssh](https://forge.puppet.com/saz/ssh) and allow access only by your username.
#
# @param allow_users Usernames to allow to login via SSH. If left default (undef),
#  ``$archlinux_workstation::username`` will be used. If ``$::virtual == 'virtualbox'``,
#  ``vagrant`` will be appended to the list.
# @param permit_root Whether or not to permit root login.
# @param extra_options extra configuration options to include in sshd_config.
#
class archlinux_workstation::ssh (
  Variant[Undef, Array[String]] $allow_users   = undef,
  Boolean $permit_root                         = false,
  Variant[Undef, Hash] $extra_options          = undef,
){

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  # variable access
  include archlinux_workstation

  if $allow_users {
    $tmp_users = $allow_users
  } else {
    $tmp_users = [$archlinux_workstation::username]
  }

  if $permit_root {
    $allow_root = 'yes'
    $tmp_users2 = $tmp_users + ['root']
  } else {
    $allow_root = 'no'
    $tmp_users2 = $tmp_users
  }

  # add 'vagrant' to allow users if on virtualbox
  if $::virtual == 'virtualbox' {
    notify {'adding vagrant to list of SSH allowed users, per $::virtual fact': }
    $real_allow_users = $tmp_users2 + ['vagrant']
  } else {
    $real_allow_users = $tmp_users2
  }

  $base_options = {
    'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
    'AllowUsers'             => $real_allow_users,
    'AuthorizedKeysFile'     => '.ssh/authorized_keys',
    'GSSAPIAuthentication'   => 'no',
    'KerberosAuthentication' => 'no',
    'PasswordAuthentication' => 'no',
    'PermitRootLogin'        => $allow_root,
    'Port'                   => [22],
    'PubkeyAuthentication'   => 'yes',
    'SyslogFacility'         => 'AUTH',
    'X11Forwarding'          => 'yes',
  }

  if $extra_options {
    validate_hash($extra_options)
    $final_options = merge($base_options, $extra_options)
  } else {
    $final_options = $base_options
  }

  # saz/ssh
  class { 'ssh::server':
    storeconfigs_enabled => false,
    options              => $final_options,
  }


}
