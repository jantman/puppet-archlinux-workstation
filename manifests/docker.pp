#
# Install and run [Docker](https://wiki.archlinux.org/index.php/Docker); add
# ``$archlinux_workstation::username`` to the ``docker`` group. This class wraps
# an instance of the [garethr/docker](https://forge.puppet.com/garethr/docker)
# module.
#
# @param service_state what state to ensure the Docker service in. This is mainly
#  useful for acceptance testing the module or building system images.
#
class archlinux_workstation::docker(
  Enum['stopped', 'running'] $service_state = 'running',
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
