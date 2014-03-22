require 'spec_helper'

describe 'archlinux_workstation::yaourt' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_file('/etc/pacman.d/archlinuxfr.conf').with({
        'ensure' => 'present',
        'owner'  => 'root',
      }) }

    end

  end

end
