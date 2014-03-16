require 'spec_helper'

describe 'archlinux_workstation' do
  context 'supported operating systems' do
    ['Archlinux'].each do |osfamily|
      describe "archlinux_workstation class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'archlinux_workstation class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_class('archlinux_workstation') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
    describe 'archlinux_workstation class without any parameters on CentOS' do
      let(:facts) {{
        :osfamily        => 'RedHat',
        :operatingsystem => 'CentOS',
      }}

      it { expect { should contain_class('archlinux_workstation') }.to raise_error(Puppet::Error, /CentOS not supported/) }
    end
    describe 'archlinux_workstation class without any parameters on Debian' do
      let(:facts) {{
        :osfamily        => 'Debian',
        :operatingsystem => 'debian',
      }}

      it { expect { should contain_class('archlinux_workstation') }.to raise_error(Puppet::Error, /debian not supported/) }
    end
  end
end
