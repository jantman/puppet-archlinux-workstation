require 'spec_helper'

describe 'archlinux_workstation::userapps::rsnapshot' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('rsync') }
      it { should contain_package('rsnapshot') }
    end

  end

end
