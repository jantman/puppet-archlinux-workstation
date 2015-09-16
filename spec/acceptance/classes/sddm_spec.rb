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
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
    
    describe package('sddm') do
      it { should be_installed }
    end

    describe service('sddm') do
      it { should be_enabled }
      it { should be_running }
    end

    describe process('/usr/bin/sddm') do
      it { should be_running }
    end

    describe process('/usr/lib/xorg-server/Xorg') do
      it { should be_running }
    end

    describe process('/usr/bin/sddm-greeter') do
      it { should be_running }
    end
  end
end
