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
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    describe package('cronie') do
      it { should be_installed }
    end

    describe service('cronie') do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/usr/lib/systemd/system/cronie.service.d') do
      it { should_not exist }
    end

    describe file('/usr/lib/systemd/system/cronie.service.d/cronie_mail_command.conf') do
      it { should_not exist }
    end
  end

  context 'mail_command specified' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::cronie': mail_command => '/foo/bar/baz', }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    describe package('cronie') do
      it { should be_installed }
    end

    describe service('cronie') do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/usr/lib/systemd/system/cronie.service.d') do
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
    end

    describe file('/usr/lib/systemd/system/cronie.service.d/cronie_mail_command.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should eq "# Managed by Puppet - archlinux_workstation::cronie class\n[Service]\nExecStart=\nExecStart=/usr/bin/crond -n -m /foo/bar/baz\n" }
    end

    describe process('crond') do
      it { should be_running }
      its(:args) { should match %r"-n -m /foo/bar/baz" }
    end
  end
end
