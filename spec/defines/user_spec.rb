require 'spec_helper'

describe 'archlinux_workstation::user', :type => :define  do

  let :title do
    'foouser'
  end

  context 'parameters' do
    let(:facts) {{
      :osfamily => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{
        :username => 'foouser',
        :realname => 'Foo User',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'name'     => 'foouser',
        'ensure'   => 'present',
        'comment'  => 'Foo User',
        'gid'      => 'foouser',
        'home'     => '/home/foouser',
        'managehome' => true,
      }) }

      it { should contain_group('foouser').with({
        'ensure' => 'present',
        'name'   => 'foouser',
        'system' => 'false',
      }) }

      it { should contain_user('foouser').that_requires('Group[foouser]') }
    end

    describe "shell specified" do
      let(:params) {{
        :shell => '/bin/zsh',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'shell'    => '/bin/zsh',
      }) }
    end

    describe "homedir specified" do
      let(:params) {{
        :homedir => '/home/notfoo',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'home'    => '/home/notfoo',
      }) }
    end

    describe "groups specified" do
      let(:params) {{
        :groups => ['one', 'two', 'three'],
      }}

      let :pre_condition do
        [
          'group { "one": ensure => present, }',
          'group { "two": ensure => present, }',
          'group { "three": ensure => present, }'
        ]
      end

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'groups'    => ['one', 'two', 'three'],
      }) }

      it do
        should contain_user('foouser').that_requires('Group[one]')
        should contain_user('foouser').that_requires('Group[two]')
        should contain_user('foouser').that_requires('Group[three]')
      end
        

    end


  end

end
