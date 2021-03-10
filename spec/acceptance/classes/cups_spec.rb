require 'spec_helper_acceptance'

describe 'archlinux_workstation::cups class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::cups': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    cups_packages = [
      'cups',
      'cups-filters',
      'cups-pdf',
      'ghostscript',
      'gsfonts',
      'gutenprint',
      'libcups',
    ]

    cups_packages.each do |pkgname|
      describe package(pkgname) do
        it { should be_installed }
      end
    end

    describe service('cups') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
