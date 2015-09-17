require 'spec_helper'

describe 'archlinux_workstation' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    # structured facts
    :os              => { 'family' => 'Archlinux' },
  }}

  context 'supported operating systems' do
    describe "archlinux_workstation class with username parameter on Archlinux" do
      let(:params) {{
        'username' => 'foouser',
      }}

      it { should compile.with_all_deps }

      it { should contain_class('archlinux_workstation') }
    end
  end

  context 'unsupported operating system' do
    describe 'archlinux_workstation class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
                     :osfamily        => 'Solaris',
                     :operatingsystem => 'Nexenta',
                     # structured facts
                     :os              => { 'family' => 'Solaris', 'name' => 'Nexenta', },
      }}

      it { expect { should contain_class('archlinux_workstation') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
    describe 'archlinux_workstation class without any parameters on CentOS' do
      let(:facts) {{
                     :osfamily        => 'RedHat',
                     :operatingsystem => 'CentOS',
                     # structured facts
                     :os              => { 'family' => 'RedHat', 'name' => 'CentOS', },
      }}

      it { expect { should contain_class('archlinux_workstation') }.to raise_error(Puppet::Error, /CentOS not supported/) }
    end
    describe 'archlinux_workstation class without any parameters on Debian' do
      let(:facts) {{
                     :osfamily        => 'Debian',
                     :operatingsystem => 'debian',
                     # structured facts
                     :os              => { 'family' => 'Debian', 'name' => 'debian', },
      }}

      it { expect { should contain_class('archlinux_workstation') }.to raise_error(Puppet::Error, /debian not supported/) }
    end
  end

  context 'parameters' do
    describe "username is undefined" do
      let(:params) {{ }}

      it { expect { should contain_class('archlinux_workstation') }.to raise_error(Puppet::Error, /Parameter username must be a string/) }
    end

    describe "username is defined" do
      let(:params) {{
        'username' => 'foouser',
      }}

      it { should compile.with_all_deps }

      it { should contain_archlinux_workstation__user('foouser').with({
        'username' => 'foouser',
        'homedir'  => '/home/foouser',
        'groups'   => ['sys'],
      }) }
    end

    describe "username and user_groups are defined" do
      let(:params) {{
                      'username'    => 'foouser',
                      'user_groups' => ['foo', 'bar'],
      }}

      it { should compile.with_all_deps }

      it { should contain_archlinux_workstation__user('foouser').with({
        'username' => 'foouser',
        'homedir'  => '/home/foouser',
        'groups'   => ['foo', 'bar'],
      }) }
    end

    describe "username and user_home are defined" do
      let(:params) {{
        'username'  => 'foouser',
        'user_home' => '/tmp/notmyhome',
      }}

      it { should compile.with_all_deps }

      it { should contain_archlinux_workstation__user('foouser').with({
        'username' => 'foouser',
        'homedir'  => '/tmp/notmyhome',
        'groups'   => ['sys'],
      }) }
    end

  end # context 'parameters'

end
