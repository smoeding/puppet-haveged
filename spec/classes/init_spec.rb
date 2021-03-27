require 'spec_helper'

describe 'haveged' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

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

          is_expected.to contain_package('haveged') \
            .with_ensure('present') \
            .with_name('haveged')

          case osver
          when 'Ubuntu-14.04'
            is_expected.to contain_file('/etc/default/haveged') \
              .with_ensure('file') \
              .with_owner('root') \
              .with_group('root') \
              .with_mode('0644') \
              .with_content(%r{^DAEMON_ARGS="-w 1024"}) \
              .that_requires('Package[haveged]') \
              .that_notifies('Service[haveged]')

            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d')
            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d/opts.conf')

          when 'Scientific-6', 'CentOS-6', 'RedHat-6', 'OracleLinux-6'
            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d')
            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d/opts.conf')
            is_expected.not_to contain_file('/etc/default/haveged')

          when 'Debian-8', 'Debian-9',
               'Ubuntu-16.04', 'Ubuntu-18.04',
               'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
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
          end

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

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        it {
          case osver
          when 'Ubuntu-14.04'
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-b 1103 -w 1024"})

          when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
               'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -b 1103})
          end
        }
      end

      context 'with parameter data_cache_size' do
        let(:params) do
          { data_cache_size: 1103 }
        end

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        it {
          case osver
          when 'Ubuntu-14.04'
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-d 1103 -w 1024"})

          when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
               'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -d 1103})
          end
        }
      end

      context 'with parameter instruction_cache_size' do
        let(:params) do
          { instruction_cache_size: 1103 }
        end

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        it {
          case osver
          when 'Ubuntu-14.04'
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-i 1103 -w 1024"})

          when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
               'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -i 1103})
          end
        }
      end

      context 'with parameter write_wakeup_threshold' do
        let(:params) do
          { write_wakeup_threshold: 1103 }
        end

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        it {
          case osver
          when 'Ubuntu-14.04'
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-w 1103"$})

          when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
               'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -w 1103$})
          end
        }
      end
    end
  end
end
