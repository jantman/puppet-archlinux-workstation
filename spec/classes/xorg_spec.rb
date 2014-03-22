require 'spec_helper'

describe 'archlinux_workstation::xorg' do
  context 'ensure present packages' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    it { should compile.with_all_deps }

    packages = ['xorg-server',
                'xorg-apps',
                'xorg-server-utils',
                'xorg-xinit',
                'mesa',
                'xf86-video-vesa'
               ]

    packages.each do |package|
      describe "package #{package}" do
        it { should contain_package(package).with_ensure('present') }
      end
    end

  end

end
