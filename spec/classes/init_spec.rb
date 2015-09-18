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
    end
  end # context 'parameters'

  context 'user management' do
    describe "default parameters" do
      let(:params) {{
                      'username' => 'foouser',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'name'       => 'foouser',
        'ensure'     => 'present',
        'comment'    => 'foouser',
        'gid'        => 'foouser',
        'home'       => '/home/foouser',
        'managehome' => true,
        'groups'     => ['sys'],
      }) }

      it { should contain_group('foouser').with({
        'ensure' => 'present',
        'name'   => 'foouser',
        'system' => 'false',
      }) }

      it { should contain_user('foouser').that_requires('Group[foouser]') }
    end # describe "default parameters"

    describe "realname specified" do
      let(:params) {{
                      'username' => 'foouser',
                      'realname' => 'Foo User',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'name'       => 'foouser',
        'ensure'     => 'present',
        'comment'    => 'Foo User',
        'gid'        => 'foouser',
        'home'       => '/home/foouser',
        'managehome' => true,
        'groups'     => ['sys'],
      }) }

      it { should contain_group('foouser').with({
        'ensure' => 'present',
        'name'   => 'foouser',
        'system' => 'false',
      }) }

      it { should contain_user('foouser').that_requires('Group[foouser]') }
    end # describe "default parameters"

    describe "shell specified" do
      let(:params) {{
                      'username' => 'foouser',
                      :shell     => '/bin/zsh',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'shell'    => '/bin/zsh',
      }) }
    end # describe "shell specified"

    describe "homedir specified" do
      let(:params) {{
                      'username' => 'foouser',
                      :user_home => '/home/notfoo',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'home'    => '/home/notfoo',
      }) }
    end # describe "homedir specified"

    describe "groups specified" do
      let(:params) {{
                      'username' => 'foouser',
                      'user_groups'  => ['one', 'two', 'three'],
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        :groups    => ['one', 'two', 'three'],
      }) }

      it do
        should contain_user('foouser').that_requires('Group[foouser]')
      end

    end # describe "groups specified"

  end

end
