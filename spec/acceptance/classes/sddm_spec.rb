require 'spec_helper_acceptance'

describe 'archlinux_workstation::sddm class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::sddm': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      # SDDM won't run properly in VirtualBox?
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(0)
    end

    describe package('sddm') do
      it { should be_installed }
    end

    # we need to wait a bit before these processes are running
    describe command('sleep 10') do
      its(:exit_status) { should eq 0 }
    end

    describe service('sddm') do
      it { should be_enabled }
      it { should be_running }
    end

    describe process('sddm') do
      it { should be_running }
    end

    describe process('Xorg') do
      it { should be_running }
    end

    describe process('sddm-greeter') do
      it { should be_running }
    end
  end
end
