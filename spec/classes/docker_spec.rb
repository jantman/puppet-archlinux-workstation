require 'spec_helper'

describe 'archlinux_workstation::docker' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    :concat_basedir  => '/tmp',
    # structured facts
    :os              => { 'family' => 'Archlinux' },
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::docker') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::docker') }
      end
    end
  end # end context 'parent class'
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
      # structured facts
      :os              => { 'family' => 'Archlinux' },
    }}
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_class('docker') }
    end

    describe 'virtual user has group added' do
      let(:params) {{ }}

      it { should compile.with_all_deps }
      it { should contain_user('myuser')
                   .with_groups(['sys', 'docker'])
                   .that_requires(['Group[myuser]', 'Class[docker]'])
      }
    end

  end

end
