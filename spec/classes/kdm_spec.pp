require 'spec_helper'

describe 'archlinux_workstation::kdm' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('kdebase-workspace') }
      it { should contain_service('kdm').with({
        'enable' => true,
      }) }

    end

  end

end
