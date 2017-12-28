#
# Sets up the [Multilib](https://wiki.archlinux.org/index.php/Multilib)
# pacman repository.
#
class archlinux_workstation::repos::multilib {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  archlinux_workstation::pacman_repo { 'multilib':
    include_file => '/etc/pacman.d/mirrorlist'
  }

}
