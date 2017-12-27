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
  end
end
