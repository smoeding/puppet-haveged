# coding: utf-8
require 'spec_helper'

describe 'haveged::config' do

  context 'On Debian with default parameters' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"\"'"
             )
    }
  end

  context 'On Debian with parameter buffer_size' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"-b 1103\"'"
             )
    }
  end

  context 'On Debian with parameter data_cache_size' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"-d 1103\"'"
             )
    }
  end

  context 'On Debian with parameter instruction_cache_size' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_augeas('set-haveged-daemon_args').with_changes(
               "set DAEMON_ARGS '\"-i 1103\"'"
             )
    }
  end

  context 'On Debian with parameter write_wakeup_threshold' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

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
