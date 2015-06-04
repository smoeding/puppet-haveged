require 'spec_helper'

describe 'haveged' do

  context 'with all default parameters' do
    it {
      should contain_class('haveged')

      should contain_class('haveged::package') \
              .that_requires('Anchor[::haveged::begin]')

      should contain_class('haveged::config') \
              .that_requires('Class[haveged::package]') \
              .that_notifies('Class[haveged::service]') \
              .with('write_wakeup_threshold' => '1024')

      should contain_class('haveged::service') \
              .that_comes_before('Anchor[::haveged::end]')
    }
  end

  context 'with service_ensure => stopped' do
    let :params do
      { :service_ensure => 'stopped' }
    end

    it {
      should contain_class('haveged')

      should contain_class('haveged::package')

      should_not contain_class('haveged::config')

      should contain_class('haveged::service') \
              .that_comes_before('Class[haveged::package]')
    }
  end

  context 'with package parameters defined' do
    let :params do
      { :package_name => 'foobar', :package_ensure => 'foo' }
    end

    it {
      should contain_class('haveged::package').with(
               'package_name'   => 'foobar',
               'package_ensure' => 'foo',
             )
    }
  end

  context 'with service parameters defined' do
    let :params do
      {
        :service_name   => 'foobar',
        :service_enable => 'foo',
        :service_ensure => 'bar',
      }
    end

    it {
      should contain_class('haveged::service').with(
               'service_name'   => 'foobar',
               'service_enable' => 'foo',
               'service_ensure' => 'bar',
             )
    }
  end

  context 'with config parameters defined' do
    let :params do
      {
        :buffer_size            => '2',
        :data_cache_size        => '3',
        :instruction_cache_size => '5',
        :write_wakeup_threshold => '7',

      }
    end

    it {
      should contain_class('haveged::config').with(
               'buffer_size'            => '2',
               'data_cache_size'        => '3',
               'instruction_cache_size' => '5',
               'write_wakeup_threshold' => '7'
             )
    }
  end

  context 'On an unsupported operating system' do
    let :facts do
      { :operatingsystem => 'VAX/VMS' }
    end

    it {
      expect { subject.call }.to raise_error(/Unsupported operatingsystem/)
    }
  end
end
