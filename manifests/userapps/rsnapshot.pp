# == Class: archlinux_workstation::userapps::rsnapshot
#
# Install rsync and rsnapshot for backups.
#
# === Actions:
#   - Install rsync, rsnapshot
#
class archlinux_workstation::userapps::rsnapshot {

  package {['rsync', 'rsnapshot']:
    ensure  => present,
  }

}
