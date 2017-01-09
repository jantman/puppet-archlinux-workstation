require 'spec_helper_acceptance'

describe 'archlinux_workstation::userapps::virtualbox class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class {'archlinux_workstation::userapps::virtualbox': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(
        apply_manifest(
          pp,
          :catch_failures => true,
          :catch_changes => true
        ).exit_code
      ).to eq(0)
    end

    packages = [
      'virtualbox',
      'virtualbox-host-dkms',
      'virtualbox-guest-iso',
      'virtualbox-ext-oracle',
    ]

    packages.each do |pkgname|
      describe package(pkgname) do
        it { should be_installed }
      end
    end

    describe file('/etc/modules-load.d/virtualbox.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should eq "# managed by puppet module archlinux_workstation\nvboxdrv\nvboxnetadp\nvboxnetflt\nvboxpci" }
    end

    describe user('myuser') do
      it { should exist }
      it { should belong_to_group 'myuser' }
      it { should belong_to_group 'sys' }
      it { should belong_to_group 'vboxusers' }
      it { should have_home_directory '/home/myuser' }
      it { should have_login_shell '/bin/bash' }
    end
  end
end
