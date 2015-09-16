####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with archlinux_workstation](#setup)
    * [What archlinux_workstation affects](#what-archlinux_workstation-affects)
4. [Requirements](#requirements)
5. [Usage - Configuration options and additional functionality](#usage)
6. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Guide for contributing to the module](#development)
    * [Adding Classes](#adding-classes)

##Overview

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active)

Provides many classes for configuring an Arch Linux workstation/laptop/desktop for graphical use and installing common software.

##Module Description

This is one of the modules that I use to keep my personal desktop and work laptop, both running Arch Linux, in sync, up to date,
and easily rebuild-able. It's intended to do three main things:

1. Manage all installed packages, and all configuration outside of ``/home``, so I don't need to back up anything outside ``/home``.
2. Keep my desktop and laptop perfectly in sync in terms of packages and global (non-user-specific) configuration.
3. Allow me to quickly rebuild one of these machines if needed, to minimize downtime.

This module is intended to be part of a whole. For me, that includes my workstation-bootstrap module ([GitHub](https://github.com/jantman/workstation-bootstrap))
that uses [r10k](https://github.com/adrienthebo/r10k), a Puppetfile, and a few manifests to actually manage what's applied to my machines and install modules,
as well as a private module ("privatepuppet") on GitHub for my sensitive/personal configuration, and a specific module for Arch Linux on my
[MacBook Pro Retina](https://github.com/jantman/puppet-archlinux-macbookretina) that handles some things specific to that platform.

__Note:__ this module is quite opinionated; it is how _I_ setup _my_ machines, and may not be exactly what you want. Pull requests are
welcome to add parameters for more control over its behavior.

##Setup

###What archlinux_workstation affects

See the [Reference](#reference) section below for details. In general, the goal is that it affects anything and everything you'd
need to touch to take a base Arch Linux installation to a fully-usable, graphical workstation/laptop/desktop.
This includes:

* your login user, a primary group with the same name as the username, and their supplementary groups
* add a Firewall rule to allow SSH access

Optionally:

* sudoers file and sudoers.d entries for your user
* sshd_config, including AllowUsers (your user only) and auth methods (pubkey/RSA only)
* ``/etc/makepkg.conf``, set to compile and cache sources under ``/tmp`` (tmpfs), and specify -j${::processorcount} make flag.
* installation of some common base packages (see ``archlinux_workstation::base_packages`` below)
* use of the [puppetlabs/firewall](http://forge.puppetlabs.com/puppetlabs/firewall) module to manage iptables (note that
  it's expected you setup the module elsewhere, as I do in [workstation_bootstrap](https://github.com/jantman/workstation-bootstrap) -
  this module just adds rules for its services using the Firewall type).
* enable dkms support by installing the package and enabling the service
* creates and uses a swapfile at a configurable path and of configurable size (by defaylt, 4G at ``/swapfile``),
  via an instance of ``archlinux_workstation::swapfile``.
* sets up the [archlinuxfr](http://archlinux.fr/yaourt-en) and [multilib](https://wiki.archlinux.org/index.php/Multilib) pacman repositories, and installs [yaourt](http://archlinux.fr/yaourt-en)
* sets up [CUPS](https://wiki.archlinux.org/index.php/Cups) printing
* sets up the [Chrony](https://wiki.archlinux.org/index.php/Chrony) alternative NTP daemon
* installs [Xorg](https://wiki.archlinux.org/index.php/Xorg) Xserver as well as related required and recommended/optional packages
  (note - this currently only installs the default vesa driver. See archlinux_workstation::xorg below for more information)
* if the ``gui`` parameter is set to 'kde' (default), installs [KDE Plasma](https://wiki.archlinux.org/index.php/KDE)
  and installs and runs [SDDM](https://wiki.archlinux.org/index.php/SDDM)
* installation of a number of different user applications (see ``archlinux_workstation::userapps::`` classes below)

##Requirements

TODO - document other requirements

* [my fork](https://github.com/jantman/puppet-ssh/tree/arch_puppet4) of [saz/ssh](https://github.com/saz/puppet-ssh) until [my pull request](https://github.com/saz/puppet-ssh/pull/149) is merged.

##Usage

Classes are parameterized where that makes sense. Right now, there are two methods of usage:

1. To install and setup _everything_ this module is capable of, declare an instance of ``archlinux_workstation`` passing the ``username`` parameter for the name of your user, and an instance of ``archlinux_workstation::all`` to do _everything_.

    class {'archlinux_workstation':
      foo => bar,
    }
    
    class {'archlinux_workstation::all': }

2. To pick and choose which parts you use, declare ``archlinux_workstation`` as shown above, and in place of ``archlinux_workstation::all``, declare the classes that you want.

If you stick to one of these two usage methods (instead of forking this module and hacking on the internals), you should be safe to pull in updates as they happen.

##Reference

### archlinux_workstation

Declares your user and group, and sets a few variables used by other classes. Also adds a Firewall
rule to allow SSH access.

#### Parameters

* __username__ - (string) Your login username. Used to create
  your account, add you to certain groups, etc. Default: undef.
* __user_home__ - Path to $username's home directory. Used for
  classes that put files in the user's home directory, and to
  create SSH keys for the user. Default: "/home/${username}.

### archlinux_workstation::base_packages

Collection of base packages that we want installed on every system.

* ensure Package lynx is absent
* ensure Packages are present: links, lsb-release, dmidecode, ttf-dejavu,
  vim, wget, bind-tools, net-tools, lsof, screen

### archlinux_workstation::chrony

Install and configure [chrony](https://wiki.archlinux.org/index.php/Chrony), a roaming/laptop friendly NTP client,
as well as the networkmanager-dispatcher-chrony script for it.

### archlinux_workstation::cronie

Install and run the [cronie](https://fedorahosted.org/cronie/) cron daemon. Per the [Arch wiki cron entry](https://wiki.archlinux.org/index.php/cron),
no cron daemon comes default with Arch.

#### Parameters

* __chrony_password__ - The password that other clients will use to
  connect to chrony. Our configuration only has chrony listening on
  localhost/127.0.0.1, so this shouldn't be important.
  Default: 'd83ja72.f83,8wHUW94'

### archlinux_workstation::cups

Installs [CUPS](https://wiki.archlinux.org/index.php/Cups) printing.

* installs cups and a list of related packages
* runs the cups service

### archlinux_workstation::dkms

Enable DMKS support

* ensure Package dkms is present
* ensure Service dkms is enabled and running

### archlinux_workstation::kde

Perform a full installation of [KDE/Plasma](https://wiki.archlinux.org/index.php/KDE) via the
"plasma-meta" and "kde-applications-meta" package groups, as well as [Phonon](https://wiki.archlinux.org/index.php/KDE#Phonon).

### archlinux_workstation::makepkg

Sets up ``/etc/makepkg.conf`` with sane Arch defaults, including compiling and caching sources
under ``/tmp`` (tmpfs), and passing make the ``-j`` flag with an argument of the number of
processors/cores on the machine, as retrieved from the "processorcount" fact.

#### Parameters

* __make_flags__ - (string) additional flags to pass to make via makepkg.conf.
  default: "-j${::processorcount}"

### archlinux_workstation::networkmanager

Install and setup networkmanager its GUI components, and ensure dhcpcd is stopped and nm is running.
If archlinux_workstation::kde is defined, install kdeplasma-applets-networkmanagement.

### archlinux_workstation::sddm

Install and run [SDDM](https://wiki.archlinux.org/index.php/SDDM) desktop manager.

### archlinux_workstation::ssh

Wrapper around [saz/ssh](https://forge.puppetlabs.com/saz/ssh) to configure SSH server.

#### Parameters

* __allow_users__ - Array of usernames to allow to login via SSH. If left default (``undef``),
  ``[$archlinux_workstation::username]`` will be used. If ``$::virtual`` == ``virtualbox``,
  "vagrant" will be appended to the list.

### archlinux_workstation::sudo

Sets up sudo, global defaults, and permissions for your user. This class simply wraps [saz/sudo](https://forge.puppetlabs.com/saz/sudo).

### Define archlinux_workstation::swapfile

Creates a swap file, makes swap, activates it and adds it to fstab

This class uses some execs to create the swapfile, then execs swapon
and uses Augeas to add the swapfile to /etc/fstab.

#### Parameters

* __swapfile_path__ - (string) path where the swapfile will be stored.
  Default: '/swapfile'. Must be an absolute path.

* __swapfile_size__ - (string) size of the swapfile, in format allowed by fallocate,
  i.e. a bare integer number of bytes, or an integer followed by K, M, G, T and so on
  for KiB, MiB, GiB, TiB, etc. Default: '4G'. NOTE that at this time, this module will
  *not* recreate swapfiles, so if you change this parameter, it will have no effect unless
  you swapoff and remove the old swapfile.

### Define archlinux_workstation::user

Defines a single user on the system, generates SSH keys,
and adds them to the usual system groups.

#### Parameters

* __username__ - (string) The user's username.
  Defaults to the resource title.
* __realname__ - (string) The user's real name, to be used
  in the passwd comment/GECOS field.
* __homedir__ - (string) Path to $username's home directory.
  Will be created if it does not exist.
* __shell__ - (string) the user's login shell.
  Default: '/bin/bash'
* __groups__ - (array) list of supplementary groups that
  this user should be a member of. Default: undef.

### archlinux_workstation::userapps::emacs

Installs emacs-nox

### archlinux_workstation::userapps::firefox

Installs Firefox

### archlinux_workstation::userapps::geppetto

Installs [Geppetto](http://docs.puppetlabs.com/geppetto/latest/index.html) Eclipse-based Puppet IDE
via AUR package, and [puppet-lint](http://puppet-lint.com/) via gem.

### archlinux_workstation::userapps::googlechrome

Install proprietary Google Chrome browser and Google TTF fonts from archlinuxfr repo.

### archlinux_workstation::userapps::irssi

Installs irssi

### archlinux_workstation::userapps::libreoffice

Installs libreoffice

### archlinux_workstation::userapps::rsnapshot

Install rsync and rsnapshot for backups.

### archlinux_workstation::userapps::rvm

Define to install [rvm](https://rvm.io/) for a single user in their home directory.

### archlinux_workstation::userapps::virtualbox

Install and configure VirtualBox and Vagrant.

### archlinux_workstation::xorg

Install packages required for xorg X server, as well as some additional packages.

Note - currently this just installs the default "xf86-video-vesa" driver.
Need to write a fact to find video cards and choose the correct driver,
per [Driver Installation](https://wiki.archlinux.org/index.php/Xorg#Driver_installation),
or expose this option to the user as a parameter.

### archlinux_workstation::yaourt

Add the [archlinuxfr](http://archlinux.fr/yaourt-en) repo to pacman via an inisetting, install
[yaourt](https://wiki.archlinux.org/index.php/Yaourt) so we can get packages from AUR.
Also enable the [multilib](https://wiki.archlinux.org/index.php/Multilib) repository (also via inisetting).

##Limitations

This module is only usable with Arch Linux. Additionally, it's generally developed against whatever the current
Puppet version is in [aur](https://aur.archlinux.org/packages/puppet), and whatever the current Ruby version is
in the [Arch Extra repo](https://www.archlinux.org/packages/extra/x86_64/ruby/).

It assumes that you have a relatively vanilla base install of Arch, such as the one I document in my [workstation-bootstrap module](https://github.com/jantman/workstation-bootstrap#arch-linux),
pretty much the same as the [Arch Linux Installation Guide](https://wiki.archlinux.org/index.php/Installation_guide) documents.

##Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for information about development and contributing.

This module currently just has spec tests; run them with:

    bundle install --path vendor
    bundle exec rake spec

###Adding Classes

To add a class:

1. Add the class itself, using the template: ``sed 's/CLASSNAME/name_of_class/g' manifests/template.txt > manifests/name_of_class.pp``
2. Add spec tests, using the template: ``sed 's/CLASSNAME/name_of_class/g' spec/classes/template.txt > spec/classes/name_of_class.pp``
3. Add acceptance tests.
4. Add the class to the [Reference](#reference) section above
5. Add the class to the ``archlinux_workstation::all`` (``manifests/all.pp``) class.
