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
    :interfaces      => 'eth0,eth1,lo',
    # structured facts
    :os              => { 'family' => 'Archlinux' },
    :processors      => { 'count' => 8 },
    :networking      => {
      'interfaces' => {
        'eth0' => {
          'dhcp' => "192.168.0.1",
          'ip' => "192.168.0.24",
        },
        'eth1' => {
          'dhcp' => "192.168.0.1",
          'ip' => "192.168.0.24",
        },
        'lo' => {
          'ip' => "127.0.0.1",
          'ip6' => "::1",
        },
      },
    }
  }
  facts.merge(additional)
end
