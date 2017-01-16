require 'spec_helper_acceptance'

describe 'archlinux_workstation::ssh class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::ssh': permit_root => true, }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq(2)
    end

    describe package('openssh') do
      it { should be_installed }
    end

    describe service('sshd') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(22) do
      it { should be_listening.on('0.0.0.0').with('tcp') }
    end

    describe file('/etc/ssh/sshd_config') do
      it { should be_file }
      its(:content) { should match /AllowUsers myuser/ }
      its(:content) { should match /AllowUsers vagrant/ }
      its(:content) { should match /AllowUsers root/ }
      its(:content) { should match /GSSAPIAuthentication no/ }
      its(:content) { should match /KerberosAuthentication no/ }
      its(:content) { should match /PasswordAuthentication no/ }
      its(:content) { should match /PermitRootLogin yes/ }
      its(:content) { should match /PubkeyAuthentication yes/ }
      its(:content) { should match /RSAAuthentication yes/ }
      its(:content) { should match /UsePrivilegeSeparation sandbox/ }
      its(:content) { should match /X11Forwarding yes/ }
    end
  end
end
