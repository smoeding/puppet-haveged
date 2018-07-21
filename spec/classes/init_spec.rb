require 'spec_helper'

describe 'haveged' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before(:each) do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      context 'with default parameters' do
        it {
          is_expected.to contain_class('haveged')

          is_expected.to contain_class('haveged::params')

          is_expected.to contain_anchor('haveged::begin')
          is_expected.to contain_anchor('haveged::end')

          is_expected.to contain_class('haveged::package') \
            .that_requires('Anchor[haveged::begin]')

          is_expected.to contain_class('haveged::config') \
            .with_write_wakeup_threshold('1024') \
            .that_requires('Class[haveged::package]') \
            .that_notifies('Class[haveged::service]')

          is_expected.to contain_class('haveged::service') \
            .that_comes_before('Anchor[haveged::end]')
        }
      end

      context 'with service_ensure => stopped' do
        let :params do
          { service_ensure: 'stopped' }
        end

        it {
          is_expected.to contain_class('haveged')

          is_expected.to contain_class('haveged::package')

          is_expected.not_to contain_class('haveged::config')

          is_expected.to contain_class('haveged::service') \
            .that_comes_before('Class[haveged::package]')
        }
      end

      context 'with package parameters defined' do
        let :params do
          {
            package_name:   'foobar',
            package_ensure: 'foo',
          }
        end

        it {
          is_expected.to contain_class('haveged::package') \
            .with_package_name('foobar') \
            .with_package_ensure('foo')
        }
      end

      context 'with service parameters defined' do
        let :params do
          {
            service_name:   'foobar',
            service_enable: 'foo',
            service_ensure: 'bar',
          }
        end

        it {
          is_expected.to contain_class('haveged::service') \
            .with_service_name('foobar') \
            .with_service_enable('foo') \
            .with_service_ensure('bar')
        }
      end

      context 'with config parameters defined' do
        let :params do
          {
            buffer_size:            '2',
            data_cache_size:        '3',
            instruction_cache_size: '5',
            write_wakeup_threshold: '7',

          }
        end

        it {
          is_expected.to contain_class('haveged::config') \
            .with_buffer_size('2') \
            .with_data_cache_size('3') \
            .with_instruction_cache_size('5') \
            .with_write_wakeup_threshold('7')
        }
      end

      context 'with package_ensure => true' do
        let :params do
          { package_ensure: true }
        end

        it {
          is_expected.to contain_class('haveged::package') \
            .with_package_ensure('present')

          is_expected.to contain_class('haveged::config') \
            .that_requires('Class[haveged::package]') \
            .that_notifies('Class[haveged::service]')

          is_expected.to contain_class('haveged::config')

          is_expected.to contain_class('haveged::service') \
            .with_service_ensure('running')
        }
      end

      context 'with package_ensure => false' do
        let :params do
          { package_ensure: false }
        end

        it {
          is_expected.to contain_class('haveged::package') \
            .with_package_ensure('purged')

          is_expected.to contain_class('haveged::service') \
            .with_service_ensure('stopped') \
            .that_comes_before('Class[haveged::package]')
        }
      end

      context 'with package_ensure => absent' do
        let :params do
          { package_ensure: 'absent' }
        end

        it {
          is_expected.to contain_class('haveged::package') \
            .with_package_ensure('purged')

          is_expected.to contain_class('haveged::service') \
            .with_service_ensure('stopped') \
            .that_comes_before('Class[haveged::package]')
        }
      end

      context 'with package_ensure => purged' do
        let :params do
          { package_ensure: 'purged' }
        end

        it {
          is_expected.to contain_class('haveged::package') \
            .with_package_ensure('purged')

          is_expected.to contain_class('haveged::service') \
            .with_service_ensure('stopped') \
            .that_comes_before('Class[haveged::package]')
        }
      end
    end
  end

  context 'on an unsupported operating system' do
    let :facts do
      {
        osfamily:        'VMS',
        operatingsystem: 'VAX/VMS',
      }
    end

    it {
      is_expected.to raise_error Puppet::Error, %r{Unsupported osfamily VMS}
    }
  end
end
