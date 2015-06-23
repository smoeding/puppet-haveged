require 'spec_helper'

describe 'haveged::config' do

  context 'on Debian with default parameters' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with(
               'ensure' => 'present',
               'match'  => '^DAEMON_ARGS',
               'line'   => 'DAEMON_ARGS=""',
               'path'   => '/etc/default/haveged',
             )

      should_not contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf')
    }
  end

  context 'on Ubuntu with default parameters' do
    let :facts do
      { :operatingsystem => 'Ubuntu' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with(
               'ensure' => 'present',
               'match'  => '^DAEMON_ARGS',
               'line'   => 'DAEMON_ARGS=""',
               'path'   => '/etc/default/haveged',
             )

      should_not contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf')
    }
  end

  context 'on RedHat with default parameters' do
    let :facts do
      { :operatingsystem => 'RedHat' }
    end

    it {
      should contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'root',
               'mode'    => '0644',
               'content' => "[Service]\nExecStart=/usr/sbin/haveged  -v 1 --Foreground\n"
             )

      should_not contain_file_line('haveged-daemon_args')
    }
  end


  context 'on CentOS with default parameters' do
    let :facts do
      { :operatingsystem => 'CentOS' }
    end

    it {
      should contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'root',
               'mode'    => '0644',
               'content' => "[Service]\nExecStart=/usr/sbin/haveged  -v 1 --Foreground\n"
             )

      should_not contain_file_line('haveged-daemon_args')
    }
  end

  context 'on Debian with parameter buffer_size' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-b 1103"'
             )
    }
  end

  context 'on CentOS with parameter buffer_size' do
    let :facts do
      { :operatingsystem => 'CentOS' }
    end

    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf').with_content(
               "[Service]\nExecStart=/usr/sbin/haveged -b 1103 -v 1 --Foreground\n"
             )
    }
  end

  context 'on Debian with parameter data_cache_size' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-d 1103"'
             )
    }
  end

  context 'on CentOS with parameter data_cache_size' do
    let :facts do
      { :operatingsystem => 'CentOS' }
    end

    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf').with_content(
               "[Service]\nExecStart=/usr/sbin/haveged -d 1103 -v 1 --Foreground\n"
             )
    }
  end

  context 'on Debian with parameter instruction_cache_size' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-i 1103"'
             )
    }
  end

  context 'on CentOS with parameter instruction_cache_size' do
    let :facts do
      { :operatingsystem => 'CentOS' }
    end

    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf').with_content(
               "[Service]\nExecStart=/usr/sbin/haveged -i 1103 -v 1 --Foreground\n"
             )
    }
  end

  context 'on Debian with parameter write_wakeup_threshold' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-w 1103"'
             )
    }
  end

  context 'on CentOS with parameter write_wakeup_threshold' do
    let :facts do
      { :operatingsystem => 'CentOS' }
    end

    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/multi-user.target.wants/haveged.service.d/opts.conf').with_content(
               "[Service]\nExecStart=/usr/sbin/haveged -w 1103 -v 1 --Foreground\n"
             )
    }
  end
end
