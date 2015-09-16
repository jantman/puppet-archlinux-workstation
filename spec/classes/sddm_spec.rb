require 'spec_helper'

describe 'archlinux_workstation::sddm' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    :concat_basedir  => '/tmp',
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::sddm') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }

        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::sddm') }
      end
    end
  end # end context 'parent class'
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}
    let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('sddm') }

      it { should contain_service('sddm').with({
                                                 'ensure' => 'running',
                                                 'enable' => true,
      }) }

    end

  end

end
