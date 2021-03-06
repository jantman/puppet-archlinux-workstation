require 'spec_helper'

describe 'archlinux_workstation::all' do
  let(:facts) { spec_facts }

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::all') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::all') }
      end
    end
  end # end context 'parent class'

  context 'child classes' do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
    describe 'classes included in all' do
      it { should contain_class('archlinux_workstation::repos::jantman') }
      it { should contain_class('archlinux_workstation::repos::multilib') }
      it { should contain_class('archlinux_workstation::base_packages') }
      it { should contain_class('archlinux_workstation::chrony') }
      it { should contain_class('archlinux_workstation::cronie') }
      it { should contain_class('archlinux_workstation::cups') }
      it { should contain_class('archlinux_workstation::dkms') }
      it { should contain_class('archlinux_workstation::docker') }
      it { should contain_class('archlinux_workstation::makepkg') }
      it { should contain_class('archlinux_workstation::networkmanager') }
      it { should contain_class('archlinux_workstation::ssh') }
      it { should contain_class('archlinux_workstation::sudo') }
      it { should contain_class('archlinux_workstation::xorg').that_comes_before('Class[archlinux_workstation::kde]') }
      it { should contain_class('archlinux_workstation::kde').that_comes_before('Class[archlinux_workstation::sddm]') }
      it { should contain_class('archlinux_workstation::sddm') }

      it { should contain_archlinux_workstation__userapps__rvm('myuser') }
      it { should contain_exec('rvm-install-myuser') }
      it { should contain_class('archlinux_workstation::userapps::virtualbox') }
      it { should contain_group('myuser') }
    end
  end

end
