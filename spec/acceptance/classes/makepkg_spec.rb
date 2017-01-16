require 'spec_helper_acceptance'

describe 'archlinux_workstation::makepkg class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser',}
      class { 'archlinux_workstation::makepkg': make_flags => '-j4',}
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    describe file('/etc/makepkg.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should match /MAKEFLAGS="-j4"/ }
      its(:content) { should match /CFLAGS="-march=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"/ }
      its(:content) { should match /CXXFLAGS="-march=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"/ }
      its(:content) { should match /BUILDENV=\(fakeroot !distcc color !ccache check !sign\)/ }
      its(:content) { should match %r"BUILDDIR=/tmp/makepkg" }
      its(:content) { should match %r"SRCDEST=/tmp/sources" }
      its(:content) { should match %r"LOGDEST=/tmp/makepkglogs" }
    end

    describe file('/tmp/sources') do
      it { should be_directory }
      it { should be_owned_by 'myuser' }
      it { should be_mode 775 }
    end

    describe file('/tmp/makepkg') do
      it { should be_directory }
      it { should be_owned_by 'myuser' }
      it { should be_mode 775 }
    end

    describe file('/tmp/makepkglogs') do
      it { should be_directory }
      it { should be_owned_by 'myuser' }
      it { should be_mode 775 }
    end

    describe file('/etc/tmpfiles.d/makepkg_puppet.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should eq "# managed by archlinux_workstation::makepkg puppet class\nD /tmp/sources 0775 myuser wheel\nD /tmp/makepkg 0775 myuser wheel\nD /tmp/makepkglogs 0775 myuser wheel" }
    end
  end

  context 'makepkg_packager specified' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'archlinux_workstation': username => 'myuser', makepkg_packager => 'Foo Bar <foo@example.com>', }
      class { 'archlinux_workstation::makepkg': make_flags => '-j4',}
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to eq(0)
    end

    describe file('/etc/makepkg.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should match /MAKEFLAGS="-j4"/ }
      its(:content) { should match /^PACKAGER='Foo Bar <foo@example.com>'/ }
      its(:content) { should match /CFLAGS="-march=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"/ }
      its(:content) { should match /CXXFLAGS="-march=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"/ }
      its(:content) { should match /BUILDENV=\(fakeroot !distcc color !ccache check !sign\)/ }
      its(:content) { should match %r"BUILDDIR=/tmp/makepkg" }
      its(:content) { should match %r"SRCDEST=/tmp/sources" }
      its(:content) { should match %r"LOGDEST=/tmp/makepkglogs" }
    end

    describe file('/tmp/sources') do
      it { should be_directory }
      it { should be_owned_by 'myuser' }
      it { should be_mode 775 }
    end

    describe file('/tmp/makepkg') do
      it { should be_directory }
      it { should be_owned_by 'myuser' }
      it { should be_mode 775 }
    end

    describe file('/tmp/makepkglogs') do
      it { should be_directory }
      it { should be_owned_by 'myuser' }
      it { should be_mode 775 }
    end

    describe file('/etc/tmpfiles.d/makepkg_puppet.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should eq "# managed by archlinux_workstation::makepkg puppet class\nD /tmp/sources 0775 myuser wheel\nD /tmp/makepkg 0775 myuser wheel\nD /tmp/makepkglogs 0775 myuser wheel" }
    end
  end
end
