require 'spec_helper'

describe 'archlinux_workstation::networkmanager' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('networkmanager') }
      it { should_not contain_package('kdeplasma-applets-networkmanagement') }
      it { should contain_service('NetworkManager').with({
        'enable' => true,
        'ensure' => 'running',
      }).that_requires('Package[networkmanager]') }
      it { should contain_service('dhcpcd').with({
        'enable' => false,
        'ensure' => 'stopped',
      }).that_requires('Service[NetworkManager]') }
    end

    describe "gui kde" do
      let(:params) {{
        'gui' => 'kde',
      }}

      it { should compile.with_all_deps }

      it { should contain_package('networkmanager') }
      it { should contain_package('kdeplasma-applets-networkmanagement')\
        .that_requires('Package[networkmanager]') }
      it { should contain_service('NetworkManager').with({
        'enable' => true,
        'ensure' => 'running',
      }).that_requires('Package[networkmanager]') }
      it { should contain_service('dhcpcd').with({
        'enable' => false,
        'ensure' => 'stopped',
      }).that_requires('Service[NetworkManager]') }
    end

  end

end
