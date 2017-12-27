require 'spec_helper_acceptance'

describe 'archlinux_workstation::xorg class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::xorg': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    packages = [
      'xorg-server',
      'xorg-xinit',
      'mesa',
      'xf86-video-vesa',
      'xterm',
      # xorg-apps is a package group
      'xorg-xauth',
      'xorg-xrandr',
      'xorg-xwd',
    ]

    packages.each do |pkgname|
      describe package(pkgname) do
        it { should be_installed }
      end
    end

    describe command('timeout -s KILL -k 5 10 startx') do
      its(:exit_status) { should eq 137 }
      its(:stderr) { should contain('X.Org X Server') }
      its(:stderr) { should contain('Current Operating System: Linux archlinux') }
      its(:stderr) { should contain('Using system config directory "/usr/share/X11/xorg.conf.d"')}
    end

    describe file('/var/log/Xorg.0.log') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:content) { should contain('(==) No Layout section.') }
      its(:content) { should contain('(==) No screen section available. Using defaults.') }
      its(:content) { should contain('(II) systemd-logind') }
      its(:content) { should contain('(II) LoadModule: "glx"') }
      its(:content) { should contain('(II) VESA: driver for VESA chipsets') }
    end
  end
end
