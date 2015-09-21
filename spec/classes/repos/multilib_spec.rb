require 'spec_helper'

describe 'archlinux_workstation::repos::multilib' do
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
        it { expect { should contain_class('archlinux_workstation::repos::multilib') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::repos::multilib') } 
      end
    end
  end # end context 'parent class'
  
  describe "class" do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
    let(:params) {{ }}

    it { should compile.with_all_deps }
    it { should contain_archlinux_workstation__pacman_repo('multilib').with({
                                                                              :include_file => '/etc/pacman.d/mirrorlist',
                                                                           })
    }
  end
end
