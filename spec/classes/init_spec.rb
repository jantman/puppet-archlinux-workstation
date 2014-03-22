require 'spec_helper'

describe 'archlinux_workstation' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
  }}

  context 'supported operating systems' do
    describe "archlinux_workstation class without any parameters on Archlinux" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_class('archlinux_workstation') }
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

  context 'parameters' do
    describe "username is undefined" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should_not contain_class('archlinux_workstation::user') }
    end

    describe "username is defined" do
      let(:params) {{
        'username' => 'foouser',
      }}

      it { should compile.with_all_deps }

      it { should contain_archlinux_workstation__user('foouser').with({
        'username' => 'foouser',
        'homedir'  => '/home/foouser',
      }) }
    end

    describe "username and user_home are defined" do
      let(:params) {{
        'username'  => 'foouser',
        'user_home' => '/tmp/notmyhome',
      }}

      it { should compile.with_all_deps }

      it { should contain_archlinux_workstation__user('foouser').with({
        'username' => 'foouser',
        'homedir'  => '/tmp/notmyhome',
      }) }
    end

    describe "gui is left default" do
      let(:params) {{
      }}

      it { should compile.with_all_deps }
      it { should contain_class('archlinux_workstation::kde') }
    end

    describe "gui is specified kde" do
      let(:params) {{
        'gui' => 'kde',
      }}

      it { should compile.with_all_deps }
      it { should contain_class('archlinux_workstation::kde') }
    end

    # @TODO: how do we set 'gui' param to undef?
#    describe "gui is set to undef" do
#      let(:params) {{
#      }}
#
#      it { should compile.with_all_deps }
#      it { should_not contain_class('archlinux_workstation::kde') }
#    end

    describe "gui is an invalid string" do
      let(:params) {{
        'gui' => 'gnome'
      }}

      it do
        expect {
          should compile
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /"gnome" does not match "\^\(kde\)\$"/)
      end
    end

  end # context 'parameters'

  context 'saz/sudo' do
    let(:params) {{
      'username' => 'foouser',
    }}

    it { should compile.with_all_deps }

    it { should contain_class('sudo') }

    it { should contain_sudo__conf('defaults-env_keep').with({
        'priority' => 0,
    }) }

    it { should contain_sudo__conf('foouser-all').with({
        'priority' => 10,
        'content'  => 'foouser ALL=(ALL) ALL',
    }) }

  end

  context 'saz/ssh' do
    let(:params) {{
      'username' => 'foouser',
    }}

    it { should compile.with_all_deps }

    it { should contain_class('ssh::server') }

    it { should contain_firewall('005 allow ssh').with({
      'port'   => [22],
      'proto'  => 'tcp',
      'action' => 'accept',
    }) }
  end

  context 'makepkg' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
      :processorcount  => 8,
    }}

    it { should compile.with_all_deps }

    it { should contain_class('archlinux_workstation::makepkg') }

  end

  context 'base_packages' do
    it { should compile.with_all_deps }

    it { should contain_class('archlinux_workstation::base_packages') }

  end

  context 'dkms' do
    it { should contain_class('archlinux_workstation::dkms') }
  end

  context 'swapfile' do

    describe 'specified path' do
      it { should contain_class('archlinux_workstation::swapfile').with({
        'swapfile_path' => '/swapfile',
      }) }
    end

    # @TODO: can't figure out how to get this to work...
    #describe 'swapfile undef' do
    #    let(:params) {{
    #      :swapfile_path => nil,
    #    }}
    #    it { should_not contain_class('archlinux_workstation::swapfile') }
    #  end

    describe 'swapfile_path specified' do
      let(:params) {{
        :swapfile_path => '/my/swap/file',
      }}
      it { should contain_class('archlinux_workstation::swapfile').with({
        'swapfile_path' => '/my/swap/file',
      }) }
    end

    describe 'swapfile_size specified' do
      let(:params) {{
        :swapfile_size => '2M',
      }}
      it { should contain_class('archlinux_workstation::swapfile').with({
        'swapfile_path' => '/swapfile',
        'swapfile_size' => '2M',
      }) }
    end

  end # context 'swapfile'

  context 'yaourt' do
    it { should contain_class('archlinux_workstation::yaourt') }
  end

  context 'cups' do
    it { should contain_class('archlinux_workstation::cups') }
  end

  context 'networkmanager' do
    describe 'default gui' do
      it { should contain_class('archlinux_workstation::networkmanager').with({
        'gui' => 'kde',
      }) }
    end
#    @TODO - need to figure out how to set param to undef
#    describe 'gui is undef' do
#      it { should contain_class('archlinux_workstation::networkmanager').with({
#        'gui' => 'undef',
#      }) }
#    end
  end

  context 'chrony' do
    it { should contain_class('archlinux_workstation::chrony') }
  end

  context 'alsa' do
    it { should contain_class('archlinux_workstation::alsa') }
  end

  context 'xorg' do
    it { should contain_class('archlinux_workstation::xorg') }
  end

end
