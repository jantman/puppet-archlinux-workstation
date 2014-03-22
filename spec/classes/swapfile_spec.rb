require 'spec_helper'

describe 'archlinux_workstation::swapfile' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_file('/swapfile').with({
        'ensure' => 'present',
        'owner'  => 'root',
        'mode'   => '0600',
      }).that_requires('Exec[fallocate-swap]') }

      it { should contain_exec('fallocate-swap').with({
        'command' => '/usr/bin/fallocate -l 4G /swapfile',
        'creates' => '/swapfile',
      }).that_notifies('Exec[mkswap-swapfile]') }

      it { should contain_exec('mkswap-swapfile').with({
        'command'     => '/usr/bin/mkswap /swapfile',
        'refreshonly' => true,
      }).that_notifies('Exec[swapon-swapfile]') }

      it { should contain_exec('swapon-swapfile').with({
        'command'     => '/usr/bin/swapon /swapfile',
        'refreshonly' => true,
      }) }

      it { should contain_augeas('swapfile').with({
        'context' => '/files/etc/fstab',
        'incl'    => '/etc/fstab',
        'lens'    => 'fstab.lns',
        'changes' => [
          "set 01/spec '/swapfile'",
          "set 01/file none",
          "set 01/vfstype swap",
          "set 01/opt defaults",
          "set 01/dump 0",
          "set 01/passno 0",
        ],
        'onlyif'  => "match *[spec='/swapfile'] size == 0",
      }) }

    end # describe "default"

    describe "specified path" do
      let(:params) {{
        :swapfile_path => '/path/to/swapfile',
      }}

      it { should compile.with_all_deps }

      it { should contain_file('/path/to/swapfile').with({
        'ensure' => 'present',
        'owner'  => 'root',
        'mode'   => '0600',
      }).that_requires('Exec[fallocate-swap]') }

      it { should contain_exec('fallocate-swap').with({
        'command' => '/usr/bin/fallocate -l 4G /path/to/swapfile',
        'creates' => '/path/to/swapfile',
      }).that_notifies('Exec[mkswap-swapfile]') }

      it { should contain_exec('mkswap-swapfile').with({
        'command'     => '/usr/bin/mkswap /path/to/swapfile',
        'refreshonly' => true,
      }).that_notifies('Exec[swapon-swapfile]') }

      it { should contain_exec('swapon-swapfile').with({
        'command'     => '/usr/bin/swapon /path/to/swapfile',
        'refreshonly' => true,
      }) }

      it { should contain_augeas('swapfile').with({
        'context' => '/files/etc/fstab',
        'incl'    => '/etc/fstab',
        'lens'    => 'fstab.lns',
        'changes' => [
          "set 01/spec '/path/to/swapfile'",
          "set 01/file none",
          "set 01/vfstype swap",
          "set 01/opt defaults",
          "set 01/dump 0",
          "set 01/passno 0",
        ],
        'onlyif'  => "match *[spec='/path/to/swapfile'] size == 0",
      }) }

    end # describe "specified path"

    describe "specified size" do
      let(:params) {{
        :swapfile_size => '1024M',
      }}

      it { should compile.with_all_deps }

      it { should contain_file('/swapfile').with({
        'ensure' => 'present',
        'owner'  => 'root',
        'mode'   => '0600',
      }).that_requires('Exec[fallocate-swap]') }

      it { should contain_exec('fallocate-swap').with({
        'command' => '/usr/bin/fallocate -l 1024M /swapfile',
        'creates' => '/swapfile',
      }).that_notifies('Exec[mkswap-swapfile]') }

      it { should contain_exec('mkswap-swapfile').with({
        'command'     => '/usr/bin/mkswap /swapfile',
        'refreshonly' => true,
      }).that_notifies('Exec[swapon-swapfile]') }

      it { should contain_exec('swapon-swapfile').with({
        'command'     => '/usr/bin/swapon /swapfile',
        'refreshonly' => true,
      }) }

      it { should contain_augeas('swapfile').with({
        'context' => '/files/etc/fstab',
        'incl'    => '/etc/fstab',
        'lens'    => 'fstab.lns',
        'changes' => [
          "set 01/spec '/swapfile'",
          "set 01/file none",
          "set 01/vfstype swap",
          "set 01/opt defaults",
          "set 01/dump 0",
          "set 01/passno 0",
        ],
        'onlyif'  => "match *[spec='/swapfile'] size == 0",
      }) }

    end # describe "specified size"

    describe "non-absolute path" do
      let(:params) {{
        :swapfile_path => 'swapfile',
      }}

      it do
        expect {
          should compile
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /"swapfile" is not an absolute path./)
      end
    end # describe "non-absolute path"

    describe "integer bytes size" do
      let(:params) {{
        :swapfile_size => '102410241024',
      }}
      it { should compile.with_all_deps }
    end # describe "integer bytes size"

    describe "invalid size suffix" do
      let(:params) {{
        :swapfile_size => '123c',
      }}
      it do
        expect {
          should compile
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /"123c" does not match "\^\[0-9\]\+\[KMGTPEZY\]\?\$"/)
      end
    end # describe "invalid size suffix"

  end # context "parameters"

end
