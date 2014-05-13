require 'spec_helper'

describe 'archlinux_workstation::cronie' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('cronie').with({ 'ensure' => 'present' }) }
      it { should contain_service('cronie').with({
        'enable' => true,
        'ensure' => 'running',
      }) }
    end
  end
end
