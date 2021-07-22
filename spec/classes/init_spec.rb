require 'spec_helper'

describe 'haveged' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        it {
          is_expected.to contain_class('haveged')
        }

        it {
          is_expected.to contain_package('haveged')
            .with_ensure('present') \
            .with_name('haveged')
        }

        case facts[:os]['family']
        when 'Debian'
          it {
            is_expected.to contain_file_line('/etc/default/haveged-DAEMON_ARGS')
              .with_path('/etc/default/haveged')
              .with_line('DAEMON_ARGS="-w 1024"')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_ensure('absent')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')
          }
        when 'RedHat'
          it {
            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_ensure('absent')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')
          }
        end

        it {
          is_expected.to contain_service('haveged')
            .with_ensure('running')
            .with_enable(true)
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

          is_expected.not_to contain_class('haveged::config')
          is_expected.not_to contain_service('haveged')
        }
      end

      context 'with package_ensure => purged' do
        let :params do
          { package_ensure: 'purged' }
        end

        it {
          is_expected.to contain_package('haveged').with_ensure('purged')

          is_expected.not_to contain_class('haveged::config')
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
          case facts[:os]['family']
          when 'Debian'
            is_expected.to contain_file_line('/etc/default/haveged-DAEMON_ARGS')
              .with_path('/etc/default/haveged')
              .with_line('DAEMON_ARGS="-w 1024 -b 1103"')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_ensure('absent')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

          when 'RedHat'
            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_content(%r{^ExecStart=.*haveged -w 1024 -b 1103 -v 1 --Foreground$})
          end
        }
      end

      context 'with parameter data_cache_size' do
        let(:params) do
          { data_cache_size: 1103 }
        end

        it {
          case facts[:os]['family']
          when 'Debian'
            is_expected.to contain_file_line('/etc/default/haveged-DAEMON_ARGS')
              .with_path('/etc/default/haveged')
              .with_line('DAEMON_ARGS="-w 1024 -d 1103"')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_ensure('absent')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

          when 'RedHat'
            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_content(%r{^ExecStart=.*haveged -w 1024 -d 1103 -v 1 --Foreground$})
          end
        }
      end

      context 'with parameter instruction_cache_size' do
        let(:params) do
          { instruction_cache_size: 1103 }
        end

        it {
          case facts[:os]['family']
          when 'Debian'
            is_expected.to contain_file_line('/etc/default/haveged-DAEMON_ARGS')
              .with_path('/etc/default/haveged')
              .with_line('DAEMON_ARGS="-w 1024 -i 1103"')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_ensure('absent')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

          when 'RedHat'
            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_content(%r{^ExecStart=.*haveged -w 1024 -i 1103 -v 1 --Foreground$})
          end
        }
      end

      context 'with parameter write_wakeup_threshold' do
        let(:params) do
          { write_wakeup_threshold: 1103 }
        end

        it {
          case facts[:os]['family']
          when 'Debian'
            is_expected.to contain_file_line('/etc/default/haveged-DAEMON_ARGS')
              .with_path('/etc/default/haveged')
              .with_line('DAEMON_ARGS="-w 1103"')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_ensure('absent')
              .that_requires('Package[haveged]')
              .that_notifies('Service[haveged]')

          when 'RedHat'
            is_expected.to contain_systemd__unit_file('haveged.service')
              .with_content(%r{^ExecStart=.*haveged -w 1103 -v 1 --Foreground$})
          end
        }
      end
    end
  end
end
