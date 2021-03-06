#
# Install and configure VirtualBox, host DKMS, guest ISO and Oracle extensions.
# Setup kernel module loading. Add ``$archlinux_workstation::username`` to
# the ``vboxusers`` group.
#
class archlinux_workstation::userapps::virtualbox {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  include archlinux_workstation

  $packages = [
              'virtualbox',
              'virtualbox-host-dkms',
              'virtualbox-guest-iso',
              'virtualbox-ext-oracle', # AUR package
              ]

  package {$packages:
    ensure => present,
  }

  file {'/etc/modules-load.d/virtualbox.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "# managed by puppet module ${module_name}\nvboxdrv\nvboxnetadp\nvboxnetflt\nvboxpci",
  }

  # add the user defined in init.pp to vboxusers group with plusignment
  User<| title == $archlinux_workstation::username |> {
    groups +> ['vboxusers'],
    require +> [ Package['virtualbox'] ],
  }

}
