require 'spec_helper'

describe 'archlinux_workstation::userapps::virtualbox' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
    # structured facts
    :os              => { 'family' => 'Archlinux' },
  }}

  context 'parent class' do
    context 'without archlinux_workstation defined' do
      describe "raises error" do
        it { expect { should contain_class('archlinux_workstation::userapps::virtualbox') }.to raise_error(Puppet::Error, /You must include the base/) }
      end
    end

    context 'with archlinux_workstation defined' do
      describe 'compiles correctly' do
        let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }

        it { should compile.with_all_deps }
        
        it { should contain_class('archlinux_workstation') }
        it { should contain_class('archlinux_workstation::userapps::virtualbox') } 
      end
    end
  end # end context 'parent class'

  context 'parameters' do
    describe "default" do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
      let(:params) {{ }}

      it { should compile.with_all_deps }

      packages = ['virtualbox',
                  'virtualbox-host-modules',
                  'virtualbox-guest-iso',
                  'virtualbox-ext-oracle',
                 ]

      packages.each do |package|
        describe "package #{package}" do
          it { should contain_package(package).with_ensure('present') }
        end
      end

      it { should contain_file('/etc/modules-load.d/virtualbox.conf')
                   .with_ensure('present')
                   .with_owner('root')
                   .with_group('root')
                   .with_mode('0644')
                   .with_content("# managed by puppet module archlinux_workstation\nvboxdrv\nvboxnetadp\nvboxnetflt\nvboxpci")
      }

    end

    describe 'virtual user has group added' do
      let(:pre_condition) { "class {'archlinux_workstation': username => 'myuser' }" }
      let(:params) {{ }}

      it { should compile.with_all_deps }
      it { should contain_user('myuser').with_groups(['sys', 'vboxusers']) }
    end
  end

end
