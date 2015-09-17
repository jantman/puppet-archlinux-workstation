require 'spec_helper'

describe 'archlinux_workstation::kde' do
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
        it { expect { should contain_class('archlinux_workstation::kde') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::kde') } 
      end
    end
  end # end context 'parent class'

  context 'parameters' do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('plasma-meta').with_ensure('present') }
      it { should contain_package('kde-applications-meta').with_ensure('present') }

      $phonon_packages = [
        'phonon-qt4',
        'phonon-qt4-gstreamer',
        'phonon-qt4-vlc',
        'phonon-qt5',
        'phonon-qt5-gstreamer',
        'phonon-qt5-vlc',
      ]
      
      $phonon_packages.each do |pkgname|
        it { should contain_package(pkgname).with_ensure('present') }
      end
    end

  end

end
