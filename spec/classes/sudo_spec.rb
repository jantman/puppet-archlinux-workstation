require 'spec_helper'

describe 'archlinux_workstation::sudo' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    # structured facts
    :os              => { 'family' => 'Archlinux' },
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::sudo') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::sudo') } 
      end
    end
  end # end context 'parent class'

  # add class-specific specs here
  context 'non-virtual' do
    describe 'includes all resources' do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should compile.with_all_deps }

      it { should contain_class('sudo') }
      it { should contain_sudo__conf('defaults-env_keep')
                   .with_priority(0)
                   .with_content('Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET QTDIR KDEDIR XDG_SESSION_COOKIE"')
      }
      it { should contain_sudo__conf('myuser-all')
                   .with_priority(10)
                   .with_content('myuser ALL=(ALL) ALL')
      }
      it { should_not contain_sudo__conf('vagrant-all') }
    end
  end
  context 'virtualbox' do
    let(:facts) {{
                   :osfamily        => 'Archlinux',
                   :operatingsystem => 'Archlinux',
                   :virtual         => 'virtualbox',
                   # structured facts
                   :os              => { 'family' => 'Archlinux' },
                 }}
    describe 'includes all resources' do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

      it { should compile.with_all_deps }

      it { should contain_class('sudo') }
      it { should contain_sudo__conf('defaults-env_keep')
                   .with_priority(0)
                   .with_content('Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET QTDIR KDEDIR XDG_SESSION_COOKIE"')
      }
      it { should contain_sudo__conf('myuser-all')
                   .with_priority(10)
                   .with_content('myuser ALL=(ALL) ALL')
      }
      it { should contain_sudo__conf('vagrant-all')
                   .with_priority(11)
                   .with_content('vagrant ALL=(ALL) NOPASSWD: ALL')
      }
    end
  end

end
