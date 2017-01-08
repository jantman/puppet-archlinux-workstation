require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet'

# helper to allow easy definition of a base set of facts for all specs
def spec_facts(additional = {})
  facts = {
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    :concat_basedir  => '/tmp',
    :processorcount  => 8,
    :puppetversion   => Puppet::PUPPETVERSION,
    :virtual         => 'physical',
    # structured facts
    :os              => { 'family' => 'Archlinux' },
    :processors      => { 'count' => 8 },
  }
  facts.merge(additional)
end
