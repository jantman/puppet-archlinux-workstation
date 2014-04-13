require 'spec_helper'

describe 'archlinux_workstation::userapps::libreoffice' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      packages = ['libreoffice-base',
                  'libreoffice-calc',
                  'libreoffice-common',
                  'libreoffice-draw',
                  'libreoffice-extension-nlpsolver',
                  'libreoffice-impress',
                  'libreoffice-kde4',
                  'libreoffice-math',
                  'libreoffice-postgresql-connector',
                  'libreoffice-sdk',
                  'libreoffice-writer',
                 ]

      packages.each do |package|
        describe "package #{package}" do
          it { should contain_package(package).with_ensure('present') }
        end
      end

      langpack_package = 'libreoffice-en-US'
      it { should contain_package(langpack_package).with_ensure('present') }

    end

  end

end
