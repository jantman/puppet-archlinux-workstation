require 'spec_helper_acceptance'

describe 'archlinux_workstation::networkmanager class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::networkmanager': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('networkmanager') do
      it { should be_installed }
    end

    describe service('NetworkManager') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('dhcpcd@eth0') do
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
  context 'with kde' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',} ->
      class { 'archlinux_workstation::kde': } ->
      class { 'archlinux_workstation::networkmanager': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('networkmanager') do
      it { should be_installed }
    end

    describe service('NetworkManager') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('dhcpcd@eth0') do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe package('plasma-nm') do
      it { should be_installed }
    end
  end
end
