require 'spec_helper'

describe 'archlinux-workstation' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "archlinux-workstation class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('archlinux-workstation::params') }
        it { should contain_class('archlinux-workstation::install').that_comes_before('archlinux-workstation::config') }
        it { should contain_class('archlinux-workstation::config') }
        it { should contain_class('archlinux-workstation::service').that_subscribes_to('archlinux-workstation::config') }

        it { should contain_service('archlinux-workstation') }
        it { should contain_package('archlinux-workstation').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'archlinux-workstation class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('archlinux-workstation') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
