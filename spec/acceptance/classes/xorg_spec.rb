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
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    packages = [
      'xorg-server',
      'xorg-server-utils',
      'xorg-xinit',
      'mesa',
      'xf86-video-vesa',
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
