require 'spec_helper'

describe 'haveged::package' do
  context 'with default parameters' do
    it {
      is_expected.to contain_package('haveged') \
        .with_ensure('present') \
        .with_name('haveged')
    }
  end

  context 'with defined parameters' do
    let :params do
      {
        package_name:   'foobar',
        package_ensure: 'foo',
      }
    end

    it {
      is_expected.to contain_package('haveged') \
        .with_ensure('foo') \
        .with_name('foobar')
    }
  end
end
