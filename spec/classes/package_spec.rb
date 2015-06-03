# coding: utf-8
require 'spec_helper'

describe 'haveged::package' do

  context 'On Debian with default parameters' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_package('haveged').with(
               'ensure' => 'installed',
               'name'   => 'haveged',
             )
    }
  end

  context 'On Debian with defined parameters' do
    let :facts do
      { :operatingsystem => 'Debian' }
    end

    let :params do
      { :package_name => 'foobar', :package_ensure => 'foo' }
    end

    it {
      should contain_package('haveged').with(
               'ensure' => 'foo',
               'name'   => 'foobar',
             )
    }
  end
end
