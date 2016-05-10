require 'spec_helper'

describe 'haveged::config' do

  context 'on Debian with default parameters' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :haveged_startup_provider => 'init',
      }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_ensure('file') \
              .with_owner('root') \
              .with_group('root') \
              .with_mode('0644') \
              .with_content(/^DAEMON_ARGS=""/)

      should_not contain_file('/etc/systemd/system/haveged.service.d')
      should_not contain_file('/etc/systemd/system/haveged.service.d/opts.conf')
    }
  end

  context 'on Ubuntu with default parameters' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :haveged_startup_provider => 'init',
      }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with(
                'ensure' => 'file',
                'owner'  => 'root',
                'group'  => 'root',
                'mode'   => '0644',
              ).with_content(/^DAEMON_ARGS=""/)

      should_not contain_file('/etc/systemd/system/haveged.service.d')
      should_not contain_file('/etc/systemd/system/haveged.service.d/opts.conf')
    }
  end

  context 'on RedHat with default parameters' do
    let :facts do
      {
        :osfamily => 'Redhat',
        :operatingsystem => 'RedHat',
        :haveged_startup_provider => 'systemd',
      }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d') \
              .with(
                'ensure' => 'directory',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0755',
              )

      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with(
                'ensure'  => 'file',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644',
              ).with_content(/^ExecStart=.*haveged --Foreground --verbose=1/)

      should_not contain_file('/etc/default/haveged')
    }
  end

  context 'on CentOS with default parameters' do
    let :facts do
      {
        :osfamily => 'Redhat',
        :operatingsystem => 'CentOS',
        :haveged_startup_provider => 'systemd',
      }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d') \
              .with(
                'ensure' => 'directory',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0755',
              )

      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with(
                'ensure'  => 'file',
                'owner'   => 'root',
                'group'   => 'root',
                'mode'    => '0644',
              ).with_content(/^ExecStart=.*haveged --Foreground --verbose=1/)

      should_not contain_file('/etc/default/haveged')
    }
  end

  context 'using init startup with parameter buffer_size' do
    let :facts do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-b 1103"/)
    }
  end

  context 'using systemd startup with parameter buffer_size' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -b 1103/)
    }
  end

  context 'using init startup with parameter data_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-d 1103"/)
    }
  end

  context 'using systemd startup with parameter data_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -d 1103/)
    }
  end

  context 'using init startup with parameter instruction_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-i 1103"/)
    }
  end

  context 'using systemd startup with parameter instruction_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -i 1103/)
    }
  end

  context 'using init startup with parameter write_wakeup_threshold' do
    let :facts do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-w 1103"$/)
    }
  end

  context 'using systemd startup with parameter write_wakeup_threshold' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -w 1103$/)
    }
  end
end
