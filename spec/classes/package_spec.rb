require 'spec_helper'

describe 'haveged::package' do

  context 'with default parameters' do
    it {
      should contain_package('haveged').with(
               'ensure' => 'installed',
               'name'   => 'haveged',
             )
    }
  end

  context 'with defined parameters' do
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
