require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # pacman update
    hosts.each do |h|
      on h, 'pacman -Syu --noconfirm' unless ENV['BEAKER_provision'] == 'no'
      run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
      install_module_dependencies_on(h)
      # on ArchLinux, install_module_on(hosts) installs in /etc/puppet/modules
      # instead of /etc/puppetlabs/code/modules
      copy_module_to(h, source: proj_root, module_name: 'archlinux_workstation', target_module_path: '/etc/puppetlabs/code/modules')
    end
    # helper for spec/acceptance/classes/userapps/rvm_spec.rb
    scp_to(hosts, File.join(proj_root, 'spec', 'test_rvm.sh'), '/tmp/test_rvm.sh')
  end
end
