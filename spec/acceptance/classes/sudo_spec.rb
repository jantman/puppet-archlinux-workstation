require 'spec_helper_acceptance'

describe 'archlinux_workstation::sudo class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::sudo': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(0)
    end

    describe package('sudo') do
      it { should be_installed }
    end

    describe file('/etc/sudoers.d/11_vagrant-all') do
      its(:content) { should match /vagrant ALL=\(ALL\) NOPASSWD: ALL/ }
    end

    describe file('/etc/sudoers.d/10_myuser-all') do
      its(:content) { should match /myuser ALL=\(ALL\) ALL/ }
    end

    describe file('/etc/sudoers.d/00_defaults-env_keep') do
      its(:content) { should match /Defaults env_keep \+= "LANG LANGUAGE LINGUAS LC_\* _XKB_CHARSET QTDIR KDEDIR XDG_SESSION_COOKIE"/ }
    end
  end
end
