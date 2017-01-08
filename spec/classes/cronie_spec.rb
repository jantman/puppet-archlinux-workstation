require 'spec_helper'

describe 'archlinux_workstation::cronie' do
  let(:facts) { spec_facts }

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::chrony') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::cronie') }
      end
    end
  end # end context 'parent class'

  context 'parameters' do
    describe "default" do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('cronie').with({ 'ensure' => 'present' }) }
      it { should contain_service('cronie').with({
                                                   'enable'  => true,
                                                   'ensure'  => 'running',
                                                   'require' => ['Package[cronie]'],
                                                 }) }
      it { should_not contain_exec('cronie-daemon-reload') }
      it { should_not contain_file('cronie.service.d') }
      it { should_not contain_file('cronie_mail_command.conf') }
    end
    describe "mail_command specified" do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
      let(:params) {{ :mail_command => '/foo/bar/baz' }}

      it { should compile.with_all_deps }

      it { should contain_package('cronie').with({ 'ensure' => 'present' }) }
      it { should contain_exec('cronie-daemon-reload').with({
                                                              'command'     => '/usr/bin/systemctl daemon-reload',
                                                              'refreshonly' => true,
                                                            })
      }
      it { should contain_service('cronie').with({
                                                   'enable'  => true,
                                                   'ensure'  => 'running',
                                                   'require' => ['Package[cronie]', 'File[cronie_mail_command.conf]', 'Exec[cronie-daemon-reload]'],
                                                 }) }
      it { should contain_file('cronie.service.d').with({
                                                          'ensure'  => 'directory',
                                                          'path'    => '/usr/lib/systemd/system/cronie.service.d',
                                                          'owner'   => 'root',
                                                          'group'   => 'root',
                                                          'mode'    => '0755',
                                                          'require' => 'Package[cronie]',
                                                        })
      }

      $content = "# Managed by Puppet - archlinux_workstation::cronie class\n[Service]\nExecStart=\nExecStart=/usr/bin/crond -n -m /foo/bar/baz\n"

      it { should contain_file('cronie_mail_command.conf').with({
                                                          'ensure'  => 'present',
                                                          'path'    => '/usr/lib/systemd/system/cronie.service.d/cronie_mail_command.conf',
                                                          'owner'   => 'root',
                                                          'group'   => 'root',
                                                          'mode'    => '0644',
                                                          'require' => 'File[cronie.service.d]',
                                                          'content' => $content,
                                                        })
      }
    end
  end

end
