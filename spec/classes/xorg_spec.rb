require 'spec_helper'

describe 'archlinux_workstation::xorg' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    :concat_basedir  => '/tmp',
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::xorg') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::xorg') } 
      end
    end
  end # end context 'parent class'

  context 'ensure present packages' do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

    it { should compile.with_all_deps }

    packages = ['xorg-server',
                'xorg-apps',
                'xorg-server-utils',
                'xorg-xinit',
                'mesa',
                'xf86-video-vesa',
                'xterm'
               ]

    packages.each do |package|
      describe "package #{package}" do
        it { should contain_package(package).with_ensure('present') }
      end
    end

  end

end
