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
               'line' => 'DAEMON_ARGS=""',
               'path'   => '/etc/default/haveged',
             )
    }
  end

  context 'with parameter buffer_size' do
    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-b 1103"'
             )
    }
  end

  context 'with parameter data_cache_size' do
    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-d 1103"'
             )
    }
  end

  context 'with parameter instruction_cache_size' do
    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-i 1103"'
             )
    }
  end

  context 'with parameter write_wakeup_threshold' do
    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_file_line('haveged-daemon_args').with_line(
               'DAEMON_ARGS="-w 1103"'
             )
    }
  end
end
