require 'spec_helper_acceptance'

describe 'archlinux_workstation::userapps::rvm class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      archlinux_workstation::userapps::rvm {'myuser': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file('/etc/gemrc') do
      it { should_not exist }
    end

    describe file('/home/myuser/.rvm') do
      it { should be_directory }
      it { should be_owned_by 'myuser' }
    end

    describe file('/home/myuser/.rvm/bin/rvm') do
      it { should be_file }
      it { should be_executable }
      it { should be_owned_by 'myuser' }
    end

    describe command('sudo -Hi -u myuser /tmp/test_rvm.sh') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain('rvm rubies') }
    end
  end
end
