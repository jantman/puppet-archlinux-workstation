require 'spec_helper'

describe 'archlinux_workstation::cups' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    let(:params) {{ }}

    it { should compile.with_all_deps }

    packages = ['libcups',
                'cups',
                'cups-filters',
                'ghostscript',
                'gsfonts',
                'gutenprint',
                'foomatic-db',
                'hplip',
                'cups-pdf'
               ]

    packages.each do |package|
      describe "package #{package}" do
        it { should contain_package(package).with_ensure('present') }
      end
    end

    it { should contain_service('cups').with({
      'enable' => true,
      'ensure' => 'running',
    }).that_requires('Package[cups]') }

  end

end
