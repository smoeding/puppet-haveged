require 'spec_helper'

describe 'haveged::config' do

  context 'with default parameters' do
    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"\"'"
             )
    }
  end

  context 'with parameter buffer_size' do
    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"-b 1103\"'"
             )
    }
  end

  context 'with parameter data_cache_size' do
    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"-d 1103\"'"
             )
    }
  end

  context 'with parameter instruction_cache_size' do
    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"-i 1103\"'"
             )
    }
  end

  context 'with parameter write_wakeup_threshold' do
    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"-w 1103\"'"
             )
    }
  end
end
