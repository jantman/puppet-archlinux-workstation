require 'spec_helper_acceptance'

describe 'archlinux_workstation::cronie class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::cronie': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
    
    describe package('cronie') do
      it { should be_installed }
    end

    describe service('cronie') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
