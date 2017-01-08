require 'spec_helper'

describe 'archlinux_workstation::networkmanager' do
  let(:facts) do
    spec_facts(
      :interfaces      => 'eth0,eth1,lo',
      :networking      => {
        'interfaces' => {
          'eth0' => {
            'dhcp' => "192.168.0.1",
            'ip' => "192.168.0.24",
          },
          'eth1' => {
            'dhcp' => "192.168.0.1",
            'ip' => "192.168.0.24",
          },
          'lo' => {
            'ip' => "127.0.0.1",
            'ip6' => "::1",
          },
        },
      }
    )
  end

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::networkmanager') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::networkmanager') }
      end
    end
  end # end context 'parent class'

  context 'parameters' do
    describe "default" do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('networkmanager') }
      it { should_not contain_package('plasma-nm') }
      it { should contain_service('NetworkManager')
                   .with({
                           'enable' => true,
                           'ensure' => 'running',
                         })
                   .that_requires('Package[networkmanager]')
      }

      it { should contain_service('dhcpcd@eth0')
                   .with({
                           'enable' => false,
                           'ensure' => 'stopped',
                         })
                   .that_requires('Service[NetworkManager]')
      }

      it { should contain_service('dhcpcd@eth1')
                   .with({
                           'enable' => false,
                           'ensure' => 'stopped',
                         })
                   .that_requires('Service[NetworkManager]')
      }

      it { should contain_service('dhcpcd@lo')
                   .with({
                           'enable' => false,
                           'ensure' => 'stopped',
                         })
                   .that_requires('Service[NetworkManager]')
      }
    end

    describe "gui kde" do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' } -> class {'archlinux_workstation::kde': }" }
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('networkmanager') }
      it { should contain_package('plasma-nm')
        .that_requires('Package[networkmanager]') }
      it { should contain_service('NetworkManager')
                   .with({
                           'enable' => true,
                           'ensure' => 'running',
                         })
                   .that_requires('Package[networkmanager]')
      }

      it { should contain_service('dhcpcd@eth0')
                   .with({
                           'enable' => false,
                           'ensure' => 'stopped',
                         })
                   .that_requires('Service[NetworkManager]')
      }

      it { should contain_service('dhcpcd@eth1')
                   .with({
                           'enable' => false,
                           'ensure' => 'stopped',
                         })
                   .that_requires('Service[NetworkManager]')
      }

      it { should contain_service('dhcpcd@lo')
                   .with({
                           'enable' => false,
                           'ensure' => 'stopped',
                         })
                   .that_requires('Service[NetworkManager]')
      }
    end

  end

end
