require 'spec_helper_acceptance'

describe 'archlinux_workstation::docker class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::docker': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
    
    describe package('docker') do
      it { should be_installed }
    end

    # we need to wait a bit before these processes are running
    describe command('sleep 10') do
      its(:exit_status) { should eq 0 }
    end
    
    describe service('docker') do
      it { should be_enabled }
      it { should be_running }
    end

    describe user('myuser') do
      it { should belong_to_group 'docker' }
    end

    describe command('docker info') do
      its(:exit_status) { should eq 0 }
    end
  end
end
