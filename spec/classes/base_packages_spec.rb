require 'spec_helper'

describe 'archlinux_workstation::base_packages' do
  let(:facts) { spec_facts }

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::base_packages') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::base_packages') }
      end
    end
  end # end context 'parent class'

  context 'ensure present packages' do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

    it { should compile.with_all_deps }

    packages = ['links',
                'lsb-release',
                'dmidecode',
                'dialog',
                'vim',
                'ttf-dejavu',
                'wget',
                'bind-tools',
                'net-tools',
                'lsof',
                'screen',
                'lsscsi'
               ]

    packages.each do |package|
      describe "package #{package}" do
        it { should contain_package(package).with_ensure('present') }
      end
    end

  end

  context 'ensure absent packages' do
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

    it { should compile.with_all_deps }

    packages_absent = ['lynx',
                      ]

    packages_absent.each do |package|
      describe "package #{package}" do
        it { should contain_package(package).with_ensure('absent') }
      end
    end
  end

end
