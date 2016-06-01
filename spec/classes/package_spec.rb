require 'spec_helper'

describe 'haveged::package' do

  context 'with default parameters' do
    it {
      should contain_package('haveged') \
              .with_ensure('present') \
              .with_name('haveged')
    }
  end

  context 'with defined parameters' do
    let :params do
      { :package_name => 'foobar', :package_ensure => 'foo' }
    end

    it {
      should contain_package(params[:package_name]).with_ensure('foo')
    }
  end
end
