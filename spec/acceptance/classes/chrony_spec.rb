require 'spec_helper_acceptance'

describe 'archlinux_workstation::chrony class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::repos::jantman': }
      class { 'archlinux_workstation::chrony': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    describe package('chrony') do
      it { should be_installed }
    end

    describe package('networkmanager-dispatcher-chrony') do
      it { should be_installed }
    end

    describe file('/etc/chrony.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      # md5sum of files/chrony.conf
      its(:md5sum) { should eq '48dc41c1eea10d438e2fab124e1eaa7d' }
    end

    describe file('/etc/chrony.keys') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 640 }
      its(:content) { should match /1 d83ja72\.f83,8wHUW94/ }
    end

    describe service('chronyd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
