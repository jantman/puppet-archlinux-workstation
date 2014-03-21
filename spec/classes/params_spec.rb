require 'spec_helper'

describe 'archlinux_workstation::params' do
  context 'supported operating systems' do
    describe "Archlinux" do
      let(:params) {{ }}
      let(:facts) {{
        :osfamily        => 'Archlinux',
        :operatingsystem => 'Archlinux',
      }}

      it { should compile.with_all_deps }

      it { should contain_class('archlinux_workstation::params') }
    end
  end

end
