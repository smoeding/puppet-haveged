# coding: utf-8
require 'spec_helper'

describe 'haveged::service' do

  context 'On Debian with default parameters' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_service('haveged').with(
               'ensure' => 'running',
               'enable' => 'true',
               'name'   => 'haveged',
             )
    }
  end

  context 'On Debian with defined parameters' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      {
        :service_name => 'foobar',
        :service_enable => 'foo',
        :service_ensure => 'bar',
      }
    end

    it {
      should contain_service('haveged').with(
               'ensure' => 'bar',
               'enable' => 'foo',
               'name'   => 'foobar',
             )
    }
  end
end
