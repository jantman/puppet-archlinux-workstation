#
# Install [CUPS](https://wiki.archlinux.org/index.php/CUPS) printing and related
# packages; run cupsd service.
#
class archlinux_workstation::cups {

  $cups_packages = [
                    'cups',
                    'cups-filters',
                    'cups-pdf',
                    'ghostscript',
                    'gsfonts',
                    'gutenprint',
                    'libcups',
                    ]

  package {$cups_packages:
    ensure => present,
  }

  service {'org.cups.cupsd':
    ensure  => running,
    enable  => true,
    require => Package['cups'],
  }

}
