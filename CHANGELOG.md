# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

[comment]: # IMPORTANT: Remember to update the links at the bottom of the file!

## Unreleased Changes

- ``sshd_config`` - Remove deprecated ``RSAAuthentication`` and ``UsePrivilegeSeparation`` options

## [0.4.0] Released 2019-03-19

- Pin some dependencies in ``.fixtures.yml`` to fix tests
- Switch acceptance tests from deprecated ``archimg/base-devel:latest`` Docker image to ``archlinux/base:latest``
- Fix Puppet4 unit tests by pinning ``puppet-module-posix-dev-r2.1`` version to 0.3.2
- ``kde`` class - stop managing ``phonon-qt4`` packages as they've been removed from the repos
- Add ``.sync.yml`` for my [modulesync_configs](https://github.com/jantman/modulesync_configs)
- Update ``.travis.yml``, ``Gemfile`` and some documentation via modulesync.
- Fix ``metadata.json`` casing of supported operatingsystem name.

## [0.3.2] Released 2017-12-28

- Add automated ``github_release`` Rake task.
- Bump puppet-blacksmith gem version and configure for signed tags.
- Reformat changelog

## [0.3.1] Released 2017-12-28

- Minor README and CONTRIBUTING documentation updates.

## [0.3.0] Released 2017-12-28

- Switch to new-style typed parameters.
- Modernize module layout and testing.
- Update supported and tested Puppet versions to 4 and 5.
- Many major puppet module dependency updates.
- Pin puppetlabs-stdlib dependency to 4.12.0, as unfortunately saz/sudo still uses the deprecated ``validate_`` functions.
- Add ``service_state`` parameter to docker class, mainly for acceptance testing
- Add ``service_ensure`` parameter to ``sddm`` class, mainly for acceptance testing
- Use puppet-strings for documentation
- Automate deployment through TravisCI

## [0.2.1] Released 2017-07-17

- Handle upstream chrony service rename to chronyd

## [0.2.0] Released 2017-07-09

- Bump saz/sudo requirement to 4.2.0+ for Arch Linux bug fix
- Remove "xorg-server-utils" package, which has been removed from repos.

## [0.1.5] Released 2016-12-05

- add management of /etc/conf.d to archlinux_workstation::docker class, as it may not already exist

## 0.1.3 Released 2016-09-01

- remove virtualbox-host-modules package in favor of virtualbox-host-dkms
- remove dkms service, as module rebuilding is now handled at install-time via alpm hooks

## 0.1.2 Released 2016-03-10

- add support for PACKAGER variable in makepkg.conf (via ``archlinux_workstation`` class variable)

## 0.1.1 Released 2015-11-25

- add support for a '-m' mail command for cronie

## 0.1.0 Released 2015-09-16

- major ground-up rewrite of module to be more reusable, and targeted at puppet4

## 0.0.1 Released 2014-03-15

- initial module creation
- migration of a bunch of stuff from https://github.com/jantman/puppet-archlinux-macbookretina

[0.4.0]: https://github.com/jantman/puppet-archlinux-workstation/compare/0.3.2...0.4.0
[0.3.2]: https://github.com/jantman/puppet-archlinux-workstation/compare/0.3.1...0.3.2
[0.3.1]: https://github.com/jantman/puppet-archlinux-workstation/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/jantman/puppet-archlinux-workstation/compare/0.2.1...0.3.0
[0.2.1]: https://github.com/jantman/puppet-archlinux-workstation/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/jantman/puppet-archlinux-workstation/compare/0.1.5...0.2.0
[0.1.5]: https://github.com/jantman/puppet-archlinux-workstation/compare/0.1.3...0.1.5
