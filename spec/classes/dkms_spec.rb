require 'spec_helper'

describe 'archlinux_workstation::dkms' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('dkms') }
      it { should contain_service('dkms').with({
        'enable' => true,
        'ensure' => 'running',
      }) }

    end

  end

end
