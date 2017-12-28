require 'spec_helper'

describe 'archlinux_workstation::chrony' do
  let(:facts) { spec_facts }

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::chrony') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' } -> class {'archlinux_workstation::repos::jantman': }" }

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::chrony') }
      end
    end
  end # end context 'parent class'

  context 'parameters' do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' } -> class {'archlinux_workstation::repos::jantman': }" }

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('chrony').with({ 'ensure' => 'present' }) }
      it { should contain_package('networkmanager-dispatcher-chrony')
                   .with({ 'ensure' => 'present' })
                   .that_requires('Class[archlinux_workstation::repos::jantman]')
      }
      it { should contain_service('chronyd').with({
        'enable' => true,
        'ensure' => 'running',
      }) }

      it { should contain_file('/etc/chrony.keys').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0640',
        }) \
        .that_requires('Package[chrony]') \
        .that_notifies('Service[chronyd]') \
        .with_content('1 d83ja72.f83,8wHUW94')
      }

      it { should contain_file('/etc/chrony.conf').with({
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        }) \
        .that_requires('Package[chrony]') \
        .that_notifies('Service[chronyd]') \
        .with_source('puppet:///modules/archlinux_workstation/chrony.conf')
      }

    end

    describe "password specified" do
      let(:params) {{
        'chrony_password' => 'foobarbaz',
      }}

      it { should compile.with_all_deps }

      it { should contain_file('/etc/chrony.keys').with_content('1 foobarbaz') }
    end
  end

end
