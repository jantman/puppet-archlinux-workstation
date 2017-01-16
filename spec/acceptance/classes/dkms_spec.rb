require 'spec_helper_acceptance'

describe 'archlinux_workstation::dkms class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::dkms': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    describe package('dkms') do
      it { should be_installed }
    end
  end
end
