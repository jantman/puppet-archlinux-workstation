#### Table of Contents

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

## Overview

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active)

Provides many classes for configuring an Arch Linux workstation/laptop/desktop for graphical use and installing common software.

## Module Description

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

## Setup

### What archlinux_workstation affects

See the [Reference](#reference) section below for details. In general, the goal is that it affects anything and everything you'd
need to touch to take a base Arch Linux installation to a fully-usable, graphical workstation/laptop/desktop.
This includes:

* your login user, a primary group with the same name as the username, and their supplementary groups

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
* sets up [CUPS](https://wiki.archlinux.org/index.php/Cups) printing
* sets up the [Chrony](https://wiki.archlinux.org/index.php/Chrony) alternative NTP daemon
* installs [Xorg](https://wiki.archlinux.org/index.php/Xorg) Xserver as well as related required and recommended/optional packages
  (note - this currently only installs the default vesa driver. See archlinux_workstation::xorg below for more information)
* if the ``gui`` parameter is set to 'kde' (default), installs [KDE Plasma](https://wiki.archlinux.org/index.php/KDE)
  and installs and runs [SDDM](https://wiki.archlinux.org/index.php/SDDM)
* sets up my [personal (jantman) pacman repo](http://archrepo.jasonantman.com/) and the [Multilib](https://wiki.archlinux.org/index.php/Multilib) repo
* installation of a number of different user applications (see ``archlinux_workstation::userapps::`` classes below)

## Usage

Classes are parameterized where that makes sense. Right now, there are two methods of usage:

1. To install and setup _everything_ this module is capable of, declare an instance of ``archlinux_workstation`` passing the ``username`` parameter for the name of your user, and an instance of ``archlinux_workstation::all`` to do _everything_.

    class {'archlinux_workstation':
      foo => bar,
    }

    class {'archlinux_workstation::all': }

2. To pick and choose which parts you use, declare ``archlinux_workstation`` as shown above, and in place of ``archlinux_workstation::all``, declare the classes that you want.

If you stick to one of these two usage methods (instead of forking this module and hacking on the internals), you should be safe to pull in updates as they happen.

## Reference

See upcoming docs.

## Limitations

This module is only usable with Arch Linux.

It assumes that you have a relatively vanilla base install of Arch, such as the one I document in my [workstation-bootstrap module](https://github.com/jantman/workstation-bootstrap#arch-linux),
pretty much the same as the [Arch Linux Installation Guide](https://wiki.archlinux.org/index.php/Installation_guide) documents.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for information about development and contributing.

This module currently just has spec tests; run them with:

    bundle install --path vendor
    bundle exec rake spec

### Adding Classes

To add a class:

1. Add the class itself, using the template: ``sed 's/CLASSNAME/name_of_class/g' manifests/template.txt > manifests/name_of_class.pp``
2. Add spec tests, using the template: ``sed 's/CLASSNAME/name_of_class/g' spec/classes/template.txt > spec/classes/name_of_class.pp``
3. Add acceptance tests.
4. Add the class to the [Reference](#reference) section above
5. Add the class to the ``archlinux_workstation::all`` (``manifests/all.pp``) class.
