require 'spec_helper'

describe 'archlinux_workstation::makepkg' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
      :processorcount  => 8,
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_file('/etc/makepkg.conf').with_content(/MAKEFLAGS="-j8"/) }
      it { should contain_file('/tmp/sources') }
      it { should contain_file('/usr/local/bin/maketmpdirs.sh') }
      it { should contain_file('/etc/systemd/system/maketmpdirs.service') }
      it { should contain_service('maketmpdirs').with({
        'ensure' => 'running',
        'enable' => true,
      }).that_requires('File[/etc/systemd/system/maketmpdirs.service]') }

    end

    describe "make_flags explicitly defined" do
      let(:params) {{
        'make_flags' => '-j1',
      }}

      it { should compile.with_all_deps }

      it do
        should contain_file('/etc/makepkg.conf') \
          .with_content(/MAKEFLAGS="-j1"/)
      end
    end

  end

end
