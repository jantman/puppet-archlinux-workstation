####Table of Contents

1. [Overview](#overview)
    * [Module Status](#module-status)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with archlinux_workstation](#setup)
    * [What archlinux_workstation affects](#what-archlinux_workstation-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Provides many classes (and a sane default class/init.pp) for configuring an Arch Linux workstation/laptop/desktop for graphical use.

###Module Status

This module is currently at version 0.0.1. I'm trying to write this in a way that's usable by other people, and meets the current
best practices for modules. However, I also need to get my new desktop up and running. While it's not best practice, this module
doesn't really have any tests yet. I plan on circling back and writing initial tests once I have a minimally-usable machine.

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

##Setup

###What archlinux_workstation affects

See the [Reference](#reference) section below for details. In general, the goal is that it affects anything and everything you'd
need to touch to take a base Arch Linux installation to a fully-usable, graphical workstation/laptop/desktop.
This includes:

* your login user, a primary group with the same name as the username, and their supplementary groups
* sudoers file and sudoers.d entries for your user
* sshd_config, including AllowUsers (your user only) and auth methods (pubkey/RSA only)
* ``/etc/makepkg.conf``, set to compile and cache sources under ``/tmp`` (tmpfs), and specify -j${::processorcount} make flag.
* installation of some common base packages (see ``archlinux_workstation::base_packages`` below)

##Usage

Classes are parameterized where that makes sense. Right now, there are two methods of usage:

1. To accept the (hopefully sane) defaults that I have, simply declare the ``archlinux_workstation`` class
   in a manifest, passing parameters as required (see [Reference](#reference) below for details on parameters).

    class {'archlinux_workstation':
      foo => bar,
    }

2. For advanced configuration, omit the main class and declare the other classes in this module, as required
   to achieve the desired effect.

If you stick to one of these two usage methods (instead of forking this module and hacking on the
internals), you should be safe to pull in updates as they happen.

##Reference

### archlinux_workstation

Simply declares instances of all of the other classes (below), passing
them the appropriate parameters. Assuming this is suitable for you,
just declare this class, passing it the appropriate parameters.

In addition, declares instances of:
* [saz/sudo](https://github.com/saz/puppet-sudo) to manage /etc/sudoers and sudoers.d entries for your user
* [saz/ssh](https://github.com/saz/puppet-ssh) to manage sshd_config

#### Parameters

* __username__ - (string) Your login username. Used to create
  your account, add you to certain groups, etc. Default: undef.
  If left undefined, this module will not do anything to users
  or groups, or anything that is user-specific.
* __user_home__ - Path to $username's home directory. Used for
  classes that put files in the user's home directory, and to
  create SSH keys for the user. Default: "/home/${username}.
  If set to undef, this module will not act on anything within
  the user's home directory.

### archlinux_workstation::base_packages

Collection of base packages that we want installed on every system.

* ensure Package lynx is absent
* ensure Packages are present: links, lsb-release, dmidecode, ttf-dejavu,
  vim, wget, dnsutils, net-tools, lsof

### archlinux_workstation::makepkg

Sets up ``/etc/makepkg.conf`` with sane Arch defaults, including compiling and caching sources
under ``/tmp`` (tmpfs), and passing make the ``-j`` flag with an argument of the number of
processors/cores on the machine, as retrieved from the "processorcount" fact.

#### Parameters

* __make_flags__ - (string) additional flags to pass to make via makepkg.conf.
  default: "-j${::processorcount}"

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

##Limitations

This module is only usable with Arch Linux. Additionally, it's generally developed against whatever the current
Puppet version is in [aur](https://aur.archlinux.org/packages/puppet), and whatever the current Ruby version is
in the [Arch Extra repo](https://www.archlinux.org/packages/extra/x86_64/ruby/).

It assumes that you have a relatively vanilla base install of Arch, such as the one I document in my [workstation-bootstrap module](https://github.com/jantman/workstation-bootstrap#arch-linux),
pretty much the same as the [Arch Linux Installation Guide](https://wiki.archlinux.org/index.php/Installation_guide) documents.

##Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for information about development and contributing.

I'm developing and testing on Arch, with everything installed via the default repositories,
or AUR (via Yaourt). At the moment, the package versions I'm using are:

* augeas 1.2.0-1
* libxml2 2.9.1-5
* puppet 3.4.2-2
* ruby 2.1.1-1
* ruby-augeas 0.5.0-0
* ruby-colored 1.2-2
* ruby-cri 2.5.0-1
* ruby-facter 1.7.5-1
* ruby-hiera 1.3.2-1
* ruby-hiera-json 0.4.0-3
* ruby-json_pure 1.8.1-1
* ruby-log4r 1.1.10-3
* ruby-r10k 1.1.4-1
* ruby-rgen 0.6.5-3
* ruby-shadow 2.2.0-2
* ruby-systemu-2.5 2.5.2-1
* vim-runtime 7.4.135-2
