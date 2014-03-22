require 'spec_helper'

describe 'archlinux_workstation::userapps::googlechrome' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    let(:pre_condition) { "class {'archlinux_workstation::yaourt': }" }

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('google-chrome').that_requires('Class[archlinux_workstation::yaourt]') }

      it { should contain_package('ttf-google-fonts-git').that_requires('Class[archlinux_workstation::yaourt]') }

    end

  end

end
