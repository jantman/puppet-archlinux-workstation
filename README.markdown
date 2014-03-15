####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with archlinux_workstation](#setup)
    * [What archlinux_workstation affects](#what-archlinux_workstation-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with archlinux_workstation](#beginning-with-archlinux_workstation)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

Provides many classes (and a sane default class/init.pp) for configuring an Arch Linux workstation/laptop/desktop for graphical use.

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

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.

###Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, etc.), mention it here. 

###Beginning with archlinux_workstation

The very basic steps needed for a user to get the module up and running. 

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

##Usage

Classes are parameterized where that makes sense. Right now, there are two methods of usage:

1. Accept my current configuration, and just apply this module (as the ``archlinux_workstation`` class).
2. 

##Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

##Limitations

This is where you list OS compatibility, version compatibility, etc.

##Development

Since your module is awesome, other users will want to play with it. Let them know what the ground rules for contributing are.

##Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You may also add any additional sections you feel are necessary or important to include here. Please use the `## ` header. 
