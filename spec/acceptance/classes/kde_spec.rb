require 'spec_helper_acceptance'

describe 'archlinux_workstation::kde class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::kde': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
    
    describe package('plasma-meta') do
      it { should be_installed }
    end

    describe package('kde-applications-meta') do
      it { should be_installed }
    end

    $phonon_packages = [
      'phonon-qt4',
      'phonon-qt4-gstreamer',
      'phonon-qt4-vlc',
      'phonon-qt5',
      'phonon-qt5-gstreamer',
      'phonon-qt5-vlc',
    ]
      
    $phonon_packages.each do |pkgname|
      describe package(pkgname) do
        it { should be_installed }
      end
    end
  end
end
