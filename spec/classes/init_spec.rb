require 'spec_helper'

describe 'haveged' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        it {
          is_expected.to contain_class('haveged')

          is_expected.to contain_package('haveged') \
            .with_ensure('present') \
            .with_name('haveged')

          is_expected.to contain_file('/etc/systemd/system/haveged.service.d') \
            .with_ensure('directory') \
            .with_owner('root') \
            .with_group('root') \
            .with_mode('0755')

          is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
            .with_ensure('file') \
            .with_owner('root') \
            .with_group('root') \
            .with_mode('0644') \
            .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1}) \
            .that_requires('Package[haveged]') \
            .that_notifies('Service[haveged]')

          is_expected.not_to contain_file('/etc/default/haveged')

          is_expected.to contain_service('haveged') \
            .with_ensure('running') \
            .with_enable(true) \
            .with_name('haveged')
        }
      end

      context 'with package_ensure => present' do
        let :params do
          { package_ensure: 'present' }
        end

        it { is_expected.to contain_package('haveged').with_ensure('present') }
      end

      context 'with package_ensure => installed' do
        let :params do
          { package_ensure: 'installed' }
        end

        it { is_expected.to contain_package('haveged').with_ensure('installed') }
      end

      context 'with package_ensure => latest' do
        let :params do
          { package_ensure: 'latest' }
        end

        it { is_expected.to contain_package('haveged').with_ensure('latest') }
      end

      context 'with package_ensure => 1.2.3' do
        let :params do
          { package_ensure: '1.2.3' }
        end

        it { is_expected.to contain_package('haveged').with_ensure('1.2.3') }
      end

      context 'with package_ensure => absent' do
        let :params do
          { package_ensure: 'absent' }
        end

        it {
          is_expected.to contain_package('haveged').with_ensure('absent')

          is_expected.not_to contain_Class('haveged::config')
          is_expected.not_to contain_service('haveged')
        }
      end

      context 'with package_ensure => purged' do
        let :params do
          { package_ensure: 'purged' }
        end

        it {
          is_expected.to contain_package('haveged').with_ensure('purged')

          is_expected.not_to contain_Class('haveged::config')
          is_expected.not_to contain_service('haveged')
        }
      end

      context 'with service_name defined' do
        let :params do
          { service_name: 'foobar' }
        end

        it { is_expected.to contain_service('haveged').with_name('foobar') }
      end

      context 'with service_ensure => stopped' do
        let :params do
          { service_ensure: 'stopped' }
        end

        it { is_expected.to contain_service('haveged').with_ensure('stopped') }
      end

      context 'with service_ensure => running' do
        let :params do
          { service_ensure: 'running' }
        end

        it { is_expected.to contain_service('haveged').with_ensure('running') }
      end

      context 'with parameter buffer_size' do
        let(:params) do
          { buffer_size: 1103 }
        end

        it {
          is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
            .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -b 1103})
        }
      end

      context 'with parameter data_cache_size' do
        let(:params) do
          { data_cache_size: 1103 }
        end

        it {
          is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
            .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -d 1103})
        }
      end

      context 'with parameter instruction_cache_size' do
        let(:params) do
          { instruction_cache_size: 1103 }
        end

        it {
          is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
            .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -i 1103})
        }
      end

      context 'with parameter write_wakeup_threshold' do
        let(:params) do
          { write_wakeup_threshold: 1103 }
        end

        it {
          is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
            .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -w 1103$})
        }
      end
    end
  end
end
