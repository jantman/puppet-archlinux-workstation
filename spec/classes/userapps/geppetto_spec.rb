require 'spec_helper'

describe 'archlinux_workstation::userapps::geppetto' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('geppetto') }

    end

  end

end
