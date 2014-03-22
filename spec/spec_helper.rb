require 'puppetlabs_spec_helper/module_spec_helper'

# per https://github.com/rodjek/rspec-puppet/issues/175
RSpec.configure do |c|
  c.before do
    # avoid "Only root can execute commands as other users"
    Puppet.features.stubs(:root? => true)
  end
end
