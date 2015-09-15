require 'spec_helper_acceptance'

describe 'archlinux_workstation class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
    
    describe user('myuser') do
      it { should exist }
      it { should belong_to_group 'myuser' }
      it { should have_home_directory '/home/myuser' }
      it { should have_login_shell '/bin/bash' }
    end

    describe group('myuser') do
      it { should exist }
    end
  end
end
