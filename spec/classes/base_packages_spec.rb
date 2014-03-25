require 'spec_helper'

describe 'archlinux_workstation::base_packages' do
  context 'ensure present packages' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    it { should compile.with_all_deps }

    packages = ['links',
                'lsb-release',
                'dmidecode',
                'vim',
                'ttf-dejavu',
                'wget',
                'dnsutils',
                'net-tools',
                'lsof',
                'screen',
               ]

    packages.each do |package|
      describe "package #{package}" do
        it { should contain_package(package).with_ensure('present') }
      end
    end

  end

  context 'ensure absent packages' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

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
