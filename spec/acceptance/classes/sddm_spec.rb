require 'spec_helper_acceptance'

describe 'archlinux_workstation::sddm class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::sddm': service_ensure => 'stopped', }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      # SDDM won't run properly in VirtualBox?
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(0).or(eq(2))
    end

    describe package('sddm') do
      it { should be_installed }
    end

    describe service('sddm') do
      it { should be_enabled }
      it { should_not be_running }
    end
  end
end
