# Class: archlinux_workstation::docker
#
# Install and run Docker.
#
# Parameters:
#
# [*service_state*]
#   Whether you want to docker daemon to start up
#   Defaults to running
#
# Actions:
#   - Wrap instance of garethr/docker
#   - Add $archlinux_workstation::user to 'docker' group
#
class archlinux_workstation::docker(
  $service_state = 'running',
) {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  include archlinux_workstation

  if ! defined(File['/etc/conf.d']) {
    file {'/etc/conf.d':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      before => Class['docker'],
    }
  }

  class {'docker':
    service_state => $service_state,
  }

  # add the user defined in init.pp to docker group with plusignment
  User<| title == $archlinux_workstation::username |> {
    groups +> ['docker'],
    require +> [ Class['docker'] ],
  }

}
