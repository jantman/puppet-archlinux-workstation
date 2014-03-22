require 'spec_helper'

describe 'archlinux_workstation::alsa' do
  context 'parameters' do
    let(:facts) {{
      :osfamily        => 'Archlinux',
      :operatingsystem => 'Archlinux',
    }}

    describe "default" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_package('alsa-utils') \
      .that_notifies('Exec[alsa-unmute-master]') }

      it { should contain_exec('alsa-unmute-master').with({
        'user'        => 'root',
        'refreshonly' => true,
        'command'     => '/usr/bin/amixer sset Master unmute',
      }).that_requires('Package[alsa-utils]') }

    end

  end

end
