require 'spec_helper'

describe 'archlinux_workstation::chrony' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('chrony').with({ 'ensure' => 'present' }) }
      it { should contain_package('networkmanager-dispatcher-chrony').with({ 'ensure' => 'present' }) }
      it { should contain_service('chrony').with({
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
        .that_notifies('Service[chrony]') \
        .with_content('1 d83ja72.f83,8wHUW94')
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
