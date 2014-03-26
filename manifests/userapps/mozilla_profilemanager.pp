# Class: archlinux_workstation::userapps::mozilla_profilemanager
#
# Install [Mozilla Profile Manager](https://developer.mozilla.org/en-US/docs/Profile_Manager)
# for Firefox. ProfileManager is a Firefox launcher that handles multiple profiles, and
# multiple running instances of Firefox.
#
# It's only available as a tarball of a binary, so we use the staging module
#  to put it in /usr/local/bin.
#
# Actions:
#   - use staging to get and extract Mozilla Profile Manager to /usr/local/bin/profilemanager
#   - setup a profilemanager .desktop link file
#
# Requires:
#
#   - nanliu/staging >=0.4.0
#
class archlinux_workstation::userapps::mozilla_profilemanager {

  staging::file { 'profilemanager.linux64.tar.gz':
    source => 'ftp://ftp.mozilla.org/pub/mozilla.org/utilities/profilemanager/1.0/profilemanager.linux64.tar.gz',
  }

  staging::extract { 'profilemanager.linux64.tar.gz':
    target  => '/usr/local/bin',
    creates => '/usr/local/bin/profilemanager/profilemanager-bin',
    require => Staging::File['profilemanager.linux64.tar.gz'],
  }

  file { '/usr/share/applications/mozilla-profilemanager.desktop':
    ensure  => present,
    source  => 'puppet:///modules/archlinux_workstation/mozilla-profilemanager.desktop',
    require => Staging::Extract['profilemanager.linux64.tar.gz'],
  }

}
