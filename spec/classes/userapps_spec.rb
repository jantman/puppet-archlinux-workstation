require 'spec_helper'

describe 'archlinux_workstation::userapps' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
  }}

  let(:pre_condition) { "class {'archlinux_workstation::yaourt': }" }

  context 'supported operating systems' do
    describe "Archlinux" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_class('archlinux_workstation::userapps') }
    end
  end

  context 'unsupported operating system' do
    describe 'Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_class('archlinux_workstation::userapps') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
    describe 'CentOS' do
      let(:facts) {{
        :osfamily        => 'RedHat',
        :operatingsystem => 'CentOS',
      }}

      it { expect { should contain_class('archlinux_workstation::userapps') }.to raise_error(Puppet::Error, /CentOS not supported/) }
    end
    describe 'Debian' do
      let(:facts) {{
        :osfamily        => 'Debian',
        :operatingsystem => 'debian',
      }}

      it { expect { should contain_class('archlinux_workstation::userapps') }.to raise_error(Puppet::Error, /debian not supported/) }
    end
  end

  context "included classes" do
    it { should compile.with_all_deps }
    it { should contain_class('archlinux_workstation::userapps::googlechrome') }
    it { should contain_class('archlinux_workstation::userapps::virtualbox') }
    it { should contain_class('archlinux_workstation::userapps::emacs') }
    it { should contain_class('archlinux_workstation::userapps::rsnapshot') }
    it { should contain_class('archlinux_workstation::userapps::firefox') }
  end

end
