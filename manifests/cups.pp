# == Class: archlinux_workstation::cups
#
# Install CUPS printing
#
# === Actions:
#   - Install cups and required/related packages
#   - Run cups service
#
class archlinux_workstation::cups {

  $cups_packages = [
                    'cups',
                    'cups-filters',
                    'cups-pdf',
                    'foomatic-db',
                    'foomatic-db-engine',
                    'foomatic-db-nonfree',
                    'ghostscript',
                    'gsfonts',
                    'gutenprint',
                    'hplip',
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

