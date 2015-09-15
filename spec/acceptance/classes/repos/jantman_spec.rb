require 'spec_helper_acceptance'

describe 'archlinux_workstation::repos::jantman class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::repos::jantman': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
    
    describe file('/etc/pacman.conf') do
      it { should be_file }
      its(:content) { should match /\[jantman\]\nSigLevel = Optional TrustedOnly\nServer = http:\/\/archrepo\.jasonantman\.com\/current/m }
    end
  end
end
