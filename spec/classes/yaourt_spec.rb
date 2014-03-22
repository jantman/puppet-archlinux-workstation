require 'spec_helper'

describe 'archlinux_workstation::yaourt' do
  let(:facts) {{
    :osfamily        => 'Archlinux',
    :operatingsystem => 'Archlinux',
  }}

  let(:params) {{ }}

  it { should compile.with_all_deps }

  it { should contain_ini_setting('pacman.conf-multilib').with({
    'ensure'  => 'present',
    'path'    => '/etc/pacman.conf',
    'section' => 'multilib',
    'setting' => 'Include',
    'value'   => '/etc/pacman.d/mirrorlist',
  }) }

  it { should contain_ini_setting('pacman.conf-archlinuxfr-siglevel').with({
    'ensure'  => 'present',
    'path'    => '/etc/pacman.conf',
    'section' => 'archlinuxfr',
    'setting' => 'SigLevel',
    'value'   => 'Never',
  }) }

  it { should contain_ini_setting('pacman.conf-archlinuxfr-server').with({
    'ensure'  => 'present',
    'path'    => '/etc/pacman.conf',
    'section' => 'archlinuxfr',
    'setting' => 'Server',
    'value'   => 'http://repo.archlinux.fr/$arch',
  }) }

  it { should contain_package('yaourt').with({
    'ensure' => 'present',
  }).that_requires('Ini_setting[pacman.conf-archlinuxfr-server]') \
  .that_requires('Ini_setting[pacman.conf-archlinuxfr-siglevel]') }

end
