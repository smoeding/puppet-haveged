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

          is_expected.to contain_package('haveged') \
            .with_ensure('present') \
            .with_name('haveged')

          is_expected.to contain_class('haveged::config') \
            .with_write_wakeup_threshold('1024') \
            .that_requires('Package[haveged]') \
            .that_notifies('Service[haveged]')

          is_expected.to contain_service('haveged') \
            .with_ensure('running') \
            .with_enable(true) \
            .with_name('haveged')
        }
      end

      context 'with service_ensure => stopped' do
        let :params do
          { service_ensure: 'stopped' }
        end

        it {
          is_expected.to contain_class('haveged')

          is_expected.to contain_package('haveged')

          is_expected.not_to contain_class('haveged::config')

          is_expected.to contain_service('haveged') \
            .with_ensure('stopped') \
            .that_comes_before('Package[haveged]')
        }
      end

      context 'with service_name defined' do
        let :params do
          { service_name: 'foobar' }
        end

        it { is_expected.to contain_service('haveged').with_name('foobar') }
      end

      context 'with service_ensure => running' do
        let :params do
          { service_ensure: 'running' }
        end

        it { is_expected.to contain_service('haveged').with_ensure('running') }
      end

      context 'with service_ensure => stopped' do
        let :params do
          { service_ensure: 'stopped' }
        end

        it { is_expected.to contain_service('haveged').with_ensure('stopped') }
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

      context 'with package_ensure => present' do
        let :params do
          { package_ensure: 'present' }
        end

        it { is_expected.to contain_package('haveged').with_ensure('present') }
      end

      context 'with package_ensure => absent' do
        let :params do
          { package_ensure: 'absent' }
        end

        it {
          is_expected.to contain_package('haveged') \
            .with_ensure('absent')

          is_expected.to contain_service('haveged') \
            .with_ensure('stopped') \
            .that_comes_before('Package[haveged]')
        }
      end

      context 'with package_ensure => purged' do
        let :params do
          { package_ensure: 'purged' }
        end

        it {
          is_expected.to contain_package('haveged') \
            .with_ensure('purged')

          is_expected.to contain_service('haveged') \
            .with_ensure('stopped') \
            .that_comes_before('Package[haveged]')
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
