require 'spec_helper'

describe 'archlinux_workstation::user', :type => :define  do

  let :title do
    'foouser'
  end

  context 'defined with' do
    let(:facts) {{
      :osfamily => 'Archlinux',
    }}

    describe "default parameters" do
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
    end # describe "default parameters"

    describe "shell specified" do
      let(:params) {{
        :shell => '/bin/zsh',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'shell'    => '/bin/zsh',
      }) }
    end # describe "shell specified"

    describe "homedir specified" do
      let(:params) {{
        :homedir => '/home/notfoo',
      }}

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        'home'    => '/home/notfoo',
      }) }
    end # describe "homedir specified"

    describe "groups specified" do
      let(:title) { 'foouser' }
      let(:params) {{
        'groups'  => ['one', 'two', 'three'],
        :homedir => '/home/foouser',
      }}

      let :pre_condition do
        [
          'group { "one": ensure => present, provider => groupadd, }',
          'group { "two": ensure => present, provider => groupadd, }',
          'group { "three": ensure => present, provider => groupadd, }',
        ]
      end

      it { should compile.with_all_deps }

      it { should contain_user('foouser').with({
        :groups    => ['one', 'two', 'three'],
      }) }

      it do
        should contain_user('foouser').that_requires('Group[one]')
        should contain_user('foouser').that_requires('Group[two]')
        should contain_user('foouser').that_requires('Group[three]')
        should contain_user('foouser').that_requires('Group[foouser]')
      end

    end # describe "groups specified"

    describe "groups not specified" do
      let(:title) { 'foouser' }

      it { should compile.with_all_deps }

      it { should contain_user('foouser').without_groups }

      it do
        should contain_user('foouser').that_requires('Group[foouser]')
      end

    end # describe "groups not specified"

  end

end
