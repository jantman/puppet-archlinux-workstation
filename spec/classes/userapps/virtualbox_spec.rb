require 'spec_helper'

describe 'archlinux_workstation::userapps::virtualbox' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    let(:pre_condition) { "class {'archlinux_workstation::yaourt': }" }

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      packages = ['virtualbox',
                  'virtualbox-host-modules',
                  'virtualbox-guest-iso',
                  'virtualbox-ext-oracle',
                 ]

      packages.each do |package|
        describe "package #{package}" do
          it { should contain_package(package).with_ensure('present') }
        end
      end

      it { should contain_file('/etc/modules-load.d/virtualbox.conf') \
           .with_content(/vboxdrv/m)
      }

    end

  end

end
