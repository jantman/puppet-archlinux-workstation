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
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
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

    describe file('/usr/local/bin/maketmpdirs.sh') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
      its(:content) { should match /ARCHUSER=myuser/ }
      its(:content) { should match /for x in sources makepkg makepkglogs; do mkdir \/tmp\/\$x ; chown \${ARCHUSER}:wheel \/tmp\/\$x ; chmod 0775 \/tmp\/\$x; done/ }
    end

    describe file('/etc/systemd/system/maketmpdirs.service') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:content) { should match %r"ExecStart=/usr/local/bin/maketmpdirs\.sh" }
      its(:content) { should match %r"Type=oneshot" }
      its(:content) { should match %r"Requires=tmp\.mount" }
      its(:md5sum) { should match /b89edc223a7fba6c7b6ebe7faaefd534/ }
    end

    describe service('maketmpdirs') do
      it { should be_enabled }
    end
  end
end
