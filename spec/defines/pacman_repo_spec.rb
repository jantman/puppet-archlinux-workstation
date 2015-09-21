require 'spec_helper'

describe 'archlinux_workstation::pacman_repo', :type => :define  do

  let :title do
    'myrepo'
  end

  context 'defined with' do
    let(:facts) {{
      :osfamily => 'Archlinux',
    }}

    describe "default parameters" do
      let(:params) {{
      }}

      it { expect { should compile.with_all_deps }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Either server or include_file must be specified on define archlinux_workstation::pacman_repo\[myrepo\]/) }
    end

    describe "standard parameters" do
      let(:params) {{
                      :server => 'http://myserver',
      }}

      it { should compile.with_all_deps }

      it { should contain_exec('pacman_repo-Sy').with({
                                                        'command'     => '/usr/bin/pacman -Sy',
                                                        'refreshonly' => 'true',
                                                      }) }

      it { should contain_ini_setting('archlinux_workstation-pacman_repo-myrepo-siglevel').with({
                                                                                                  'ensure'  => 'present',
                                                                                                  'path'    => '/etc/pacman.conf',
                                                                                                  'section' => 'myrepo',
                                                                                                  'setting' => 'SigLevel',
                                                                                                  'value'   => 'Optional TrustedOnly',
                                                                                                  'notify'  => 'Exec[pacman_repo-Sy]',
                                                                                                })
      }

      it { should contain_ini_setting('archlinux_workstation-pacman_repo-myrepo-server').with({
                                                                                                'ensure'  => 'present',
                                                                                                'path'    => '/etc/pacman.conf',
                                                                                                'section' => 'myrepo',
                                                                                                'setting' => 'Server',
                                                                                                'value'   => 'http://myserver',
                                                                                                'notify'  => 'Exec[pacman_repo-Sy]',
                                                                                              })
      }
    end

    describe "specified repo_name" do
      let(:params) {{
                      :server    => 'http://myserver',
                      :repo_name => 'arepo',
      }}

      it { should compile.with_all_deps }

      it { should contain_exec('pacman_repo-Sy').with({
                                                        'command'     => '/usr/bin/pacman -Sy',
                                                        'refreshonly' => 'true',
                                                      }) }

      it { should contain_ini_setting('archlinux_workstation-pacman_repo-myrepo-siglevel').with({
                                                                                                  'ensure'  => 'present',
                                                                                                  'path'    => '/etc/pacman.conf',
                                                                                                  'section' => 'arepo',
                                                                                                  'setting' => 'SigLevel',
                                                                                                  'value'   => 'Optional TrustedOnly',
                                                                                                  'notify'  => 'Exec[pacman_repo-Sy]',
                                                                                                })
      }

      it { should contain_ini_setting('archlinux_workstation-pacman_repo-myrepo-server').with({
                                                                                                'ensure'  => 'present',
                                                                                                'path'    => '/etc/pacman.conf',
                                                                                                'section' => 'arepo',
                                                                                                'setting' => 'Server',
                                                                                                'value'   => 'http://myserver',
                                                                                                'notify'  => 'Exec[pacman_repo-Sy]',
                                                                                              })
      }
    end

    describe "specified siglevel" do
      let(:params) {{
                      :server   => 'http://myserver',
                      :siglevel => 'foo',
      }}

      it { should compile.with_all_deps }

      it { should contain_exec('pacman_repo-Sy').with({
                                                        'command'     => '/usr/bin/pacman -Sy',
                                                        'refreshonly' => 'true',
                                                      }) }

      it { should contain_ini_setting('archlinux_workstation-pacman_repo-myrepo-siglevel').with({
                                                                                                  'ensure'  => 'present',
                                                                                                  'path'    => '/etc/pacman.conf',
                                                                                                  'section' => 'myrepo',
                                                                                                  'setting' => 'SigLevel',
                                                                                                  'value'   => 'foo',
                                                                                                  'notify'  => 'Exec[pacman_repo-Sy]',
                                                                                                })
      }

      it { should contain_ini_setting('archlinux_workstation-pacman_repo-myrepo-server').with({
                                                                                                'ensure'  => 'present',
                                                                                                'path'    => '/etc/pacman.conf',
                                                                                                'section' => 'myrepo',
                                                                                                'setting' => 'Server',
                                                                                                'value'   => 'http://myserver',
                                                                                                'notify'  => 'Exec[pacman_repo-Sy]',
                                                                                              })
      }
    end

    describe "include_file" do
      let(:params) {{
                      :include_file => '/foo/bar',
      }}

      it { should compile.with_all_deps }

      it { should contain_exec('pacman_repo-Sy').with({
                                                        'command'     => '/usr/bin/pacman -Sy',
                                                        'refreshonly' => 'true',
                                                      }) }

      it { should contain_ini_setting('archlinux_workstation-pacman_repo-myrepo-include').with({
                                                                                                  'ensure'  => 'present',
                                                                                                  'path'    => '/etc/pacman.conf',
                                                                                                  'section' => 'myrepo',
                                                                                                  'setting' => 'Include',
                                                                                                  'value'   => '/foo/bar',
                                                                                                  'notify'  => 'Exec[pacman_repo-Sy]',
                                                                                                })
      }
    end
  end
end
