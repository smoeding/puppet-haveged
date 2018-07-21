require 'spec_helper'

describe 'haveged' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
      osver = "#{facts[:operatingsystem]}-#{osrel}"

      case osver
      when 'Ubuntu-14.04'
        let(:facts) { facts.merge(haveged_startup_provider: 'init') }
      when 'Scientific-6', 'CentOS-6', 'RedHat-6', 'OracleLinux-6'
        let(:facts) { facts.merge(haveged_startup_provider: 'init') }
      when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
           'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
        let(:facts) { facts.merge(haveged_startup_provider: 'systemd') }
      end

      context 'with default parameters' do
        it {
          is_expected.to contain_class('haveged')

          is_expected.to contain_class('haveged::params')

          is_expected.to contain_class('haveged::package')

          is_expected.to contain_class('haveged::config') \
            .with_write_wakeup_threshold('1024') \
            .that_requires('Class[haveged::package]') \
            .that_notifies('Class[haveged::service]')

          is_expected.to contain_class('haveged::service')
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
            buffer_size:            2,
            data_cache_size:        3,
            instruction_cache_size: 5,
            write_wakeup_threshold: 7,

          }
        end

        it {
          is_expected.to contain_class('haveged::config') \
            .with_buffer_size(2) \
            .with_data_cache_size(3) \
            .with_instruction_cache_size(5) \
            .with_write_wakeup_threshold(7)
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
