require 'spec_helper'

describe 'archlinux_workstation' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "archlinux_workstation class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation::params') }
        it { should contain_class('archlinux_workstation::install').that_comes_before('archlinux_workstation::config') }
        it { should contain_class('archlinux_workstation::config') }
        it { should contain_class('archlinux_workstation::service').that_subscribes_to('archlinux_workstation::config') }

        it { should contain_service('archlinux_workstation') }
        it { should contain_package('archlinux_workstation').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'archlinux_workstation class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('archlinux_workstation') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
