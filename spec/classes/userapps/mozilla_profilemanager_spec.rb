require 'spec_helper'

describe 'archlinux_workstation::userapps::mozilla_profilemanager' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    let(:pre_condition) { "class {'archlinux_workstation::yaourt': }" }

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_staging__file('profilemanager.linux64.tar.gz').with({
        'source' => 'ftp://ftp.mozilla.org/pub/mozilla.org/utilities/profilemanager/1.0/profilemanager.linux64.tar.gz',
      }) }

      it { should contain_staging__extract('profilemanager.linux64.tar.gz').with({
        'target'  => '/usr/local/bin',
        'creates' => '/usr/local/bin/profilemanager/profilemanager-bin',
      }).that_requires('Staging::File[profilemanager.linux64.tar.gz]') }

      it { should contain_file('/usr/share/applications/mozilla-profilemanager.desktop').with({
        'ensure'  => 'present',
        'source'  => 'puppet:///modules/archlinux_workstation/mozilla-profilemanager.desktop',
      }).that_requires('Staging::Extract[profilemanager.linux64.tar.gz]') }

    end

  end

end
