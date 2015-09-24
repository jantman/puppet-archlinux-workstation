require 'spec_helper'

describe 'archlinux_workstation::ssh' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    :concat_basedir  => '/tmp',
    # structured facts
    :os              => { 'family' => 'Archlinux' },
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::ssh') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::ssh') } 
      end
    end
  end # end context 'parent class'

  # add class-specific specs here
  context 'not on virtualbox' do
    describe 'without parameters' do
      let(:params) {{ }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['myuser'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'no',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                      }
                                                    })
      }
    end

    describe 'with extra_options specified' do
      let(:params) {{
                      :extra_options => {'foo' => 'bar'}
                    }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['myuser'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'no',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                        'foo'                    => 'bar',
                                                      }
                                                    })
      }
    end

    describe 'with specified allow_users' do
      let(:params) {{ :allow_users => ['foo', 'bar'] }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['foo', 'bar'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'no',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                      }
                                                    })
      }
    end
    describe 'with permit_root true' do
      let(:params) {{ :permit_root => true }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['myuser', 'root'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'yes',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                      }
                                                    })
      }
    end

    describe 'with permit_root true and allow_users' do
      let(:params) {{ :permit_root => true, :allow_users => ['foo', 'bar'] }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['foo', 'bar', 'root'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'yes',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                      }
                                                    })
      }
    end
  end

  context 'on virtualbox' do
    let(:facts) {{
                   :osfamily        => 'Archlinux',
                   :operatingsystem => 'Archlinux',
                   :concat_basedir  => '/tmp',
                   :virtual         => 'virtualbox',
                   # structured facts
                   :os              => { 'family' => 'Archlinux' },
                 }}

    describe 'without parameters' do
      let(:params) {{ }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['myuser', 'vagrant'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'no',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                      }
                                                    })
      }
    end

    describe 'with specified allow_users' do
      let(:params) {{ :allow_users => ['foo', 'bar'] }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['foo', 'bar', 'vagrant'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'no',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                      }
                                                    })
      }
    end
    describe 'with permit_root true' do
      let(:params) {{ :permit_root => true }}
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should contain_class('ssh::server').with({
                                                      :storeconfigs_enabled => false,
                                                      :options              => {
                                                        'AcceptEnv'              => ['LANG', 'LC_*', 'DISPLAY'],
                                                        'AllowUsers'             => ['myuser', 'root', 'vagrant'],
                                                        'AuthorizedKeysFile'     => '.ssh/authorized_keys',
                                                        'GSSAPIAuthentication'   => 'no',
                                                        'KerberosAuthentication' => 'no',
                                                        'PasswordAuthentication' => 'no',
                                                        'PermitRootLogin'        => 'yes',
                                                        'Port'                   => [22],
                                                        'PubkeyAuthentication'   => 'yes',
                                                        'RSAAuthentication'      => 'yes',
                                                        'SyslogFacility'         => 'AUTH',
                                                        'UsePrivilegeSeparation' => 'sandbox',
                                                        'X11Forwarding'          => 'yes',
                                                      }
                                                    })
      }
    end
  end

end
