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
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    cups_packages = [
      'cups',
      'cups-filters',
      'cups-pdf',
      'foomatic-db',
      'foomatic-db-engine',
      'foomatic-db-nonfree',
      'ghostscript',
      'gsfonts',
      'gutenprint',
      'hplip',
      'libcups',
    ]

    cups_packages.each do |pkgname|
      describe package(pkgname) do
        it { should be_installed }
      end
    end

    describe service('org.cups.cupsd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
