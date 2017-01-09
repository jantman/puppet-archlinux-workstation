require 'spec_helper_acceptance'

describe 'archlinux_workstation::base_packages class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',} ->
      class { 'archlinux_workstation::base_packages': }
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

    packages_absent = [
      'lynx',
    ]

    packages_present = [
      'bind-tools',
      'dmidecode',
      'dialog',
      'links',
      'lsb-release',
      'lsof',
      'lsscsi',
      'net-tools',
      'screen',
      'ttf-dejavu',
      'vim',
      'wget',
    ]

    packages_present.each do |pkgname|
      describe package(pkgname) do
        it { should be_installed }
      end
    end

    packages_absent.each do |pkgname|
      describe package(pkgname) do
        it { should_not be_installed }
      end
    end
  end
end
