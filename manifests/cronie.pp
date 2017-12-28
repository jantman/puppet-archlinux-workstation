#
# Install and run the [cronie](https://fedorahosted.org/cronie/) cron daemon.
# Per the [Arch wiki cron entry](https://wiki.archlinux.org/index.php/cron),
# no cron daemon comes default with Arch.
#
# @param mail_command If defined, will run `cronie`
#   with ``-m ${mail_command}`` to send mail via this command.
#   See `man 8 cron` for more information.
#
class archlinux_workstation::cronie (
  Variant[String, Undef] $mail_command = undef,
) {

  if ! defined(Class['archlinux_workstation']) {
    fail('You must include the base archlinux_workstation class before using any subclasses')
  }

  package {'cronie':
    ensure => present,
  }

  if $mail_command {
    exec {'cronie-daemon-reload':
      command     => '/usr/bin/systemctl daemon-reload',
      refreshonly => true,
    }

    file {'cronie.service.d':
      ensure  => directory,
      path    => '/usr/lib/systemd/system/cronie.service.d',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['cronie'],
    }

    $mail_cmd_content = "# Managed by Puppet - archlinux_workstation::cronie class
[Service]
ExecStart=
ExecStart=/usr/bin/crond -n -m ${mail_command}
"

    file {'cronie_mail_command.conf':
      ensure  => present,
      path    => '/usr/lib/systemd/system/cronie.service.d/cronie_mail_command.conf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File['cronie.service.d'],
      content => $mail_cmd_content,
      notify  => [Exec['cronie-daemon-reload'], Service['cronie']],
    }

    $svc_require = [Package['cronie'], File['cronie_mail_command.conf'], Exec['cronie-daemon-reload']]
  } else {
    $svc_require = [Package['cronie']]
  }

  service {'cronie':
    ensure  => running,
    enable  => true,
    require => $svc_require,
  }

}
