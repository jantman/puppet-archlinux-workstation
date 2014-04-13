# == Class: archlinux_workstation::userapps::libreoffice
#
# Install a simple selection of the LibreOffice packages
#
# === Actions:
#   - Install LibreOffice packages
#
class archlinux_workstation::userapps::libreoffice {

  $langpack_package = 'libreoffice-en-US' # @TODO - make this a param

  $packages = [
              'libreoffice-base',
              'libreoffice-calc',
              'libreoffice-common',
              'libreoffice-draw',
              'libreoffice-extension-nlpsolver',
              'libreoffice-impress',
              'libreoffice-kde4',
              'libreoffice-math',
              'libreoffice-postgresql-connector',
              'libreoffice-sdk',
              'libreoffice-writer',
              ]

  package {$packages:
    ensure  => present,
  }

  package {$langpack_package:
    ensure  => present,
  }

}
