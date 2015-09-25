# Class: archlinux_workstation::docker
#
# Install and run Docker.
#
# Parameters:
#
# Actions:
#   - Wrap instance of garethr/docker
#   - Add $archlinux_workstation::user to 'docker' group
#
class archlinux_workstation::docker {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  include archlinux_workstation

  include docker

  # add the user defined in init.pp to docker group with plusignment
  User<| title == $archlinux_workstation::username |> {
    groups +> ['docker'],
    require +> [ Class['docker'] ],
  }

}
