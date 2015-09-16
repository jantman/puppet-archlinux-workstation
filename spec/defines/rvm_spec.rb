require 'spec_helper'

describe 'archlinux_workstation::userapps::rvm', :type => :define  do

  let :title do
    'foouser'
  end

  context 'defined with' do
    let(:facts) {{
      :osfamily => 'Archlinux',
    }}

    describe "default parameters" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_exec('rvm-install-foouser').with({
        'command'     => 'curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles',
        'creates'     => '/home/foouser/.rvm/bin/rvm',
        'user'        => 'foouser',
        'cwd'         => '/home/foouser',
        'path'        => '/usr/bin:/bin',
        'environment' => 'HOME=/home/foouser',
        'require'     => 'File[/etc/gemrc]',
                                                           })
      }

      it { should contain_file('/etc/gemrc').with_ensure('absent') }
    end # describe "default parameters"

    describe "homedir specified" do
      let(:params) {{
        :userhome => '/not/usual/home',
      }}

      it { should compile.with_all_deps }

      it { should contain_exec('rvm-install-foouser').with({
        'command'     => 'curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles',
        'creates'     => '/not/usual/home/.rvm/bin/rvm',
        'user'        => 'foouser',
        'cwd'         => '/not/usual/home',
        'path'        => '/usr/bin:/bin',
        'environment' => 'HOME=/not/usual/home',
        'require'     => 'File[/etc/gemrc]',
      }) }

      it { should contain_file('/etc/gemrc').with_ensure('absent') }
    end # describe "shell specified"

  end

end
