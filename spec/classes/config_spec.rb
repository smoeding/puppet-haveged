require 'spec_helper'

describe 'haveged::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before(:each) do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
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
      end

      context 'with default parameters' do
        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        case osver
        when 'Ubuntu-14.04'
          it {
            is_expected.to contain_file('/etc/default/haveged') \
              .with_ensure('file') \
              .with_owner('root') \
              .with_group('root') \
              .with_mode('0644') \
              .with_content(%r{^DAEMON_ARGS=""})

            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d')
            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d/opts.conf')
          }

        when 'Scientific-6', 'CentOS-6', 'RedHat-6', 'OracleLinux-6'
          it {
            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d')
            is_expected.not_to contain_file('/etc/systemd/system/haveged.service.d/opts.conf')
            is_expected.not_to contain_file('/etc/default/haveged')
          }

        when 'Debian-8', 'Debian-9',
             'Ubuntu-16.04', 'Ubuntu-18.04',
             'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
          it {
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
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1})

            is_expected.not_to contain_file('/etc/default/haveged')
          }

        else
          # fail if actual os is not tested here
          it { expect(osver).to eq('osver') }
        end
      end

      context 'with parameter buffer_size' do
        let(:params) do
          { buffer_size: '1103' }
        end

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        case osver
        when 'Ubuntu-14.04'
          it {
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-b 1103"})
          }

        when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
             'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
          it {
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -b 1103})
          }
        end
      end

      context 'with parameter data_cache_size' do
        let(:params) do
          { data_cache_size: '1103' }
        end

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        case osver
        when 'Ubuntu-14.04'
          it {
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-d 1103"})
          }

        when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
             'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
          it {
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -d 1103})
          }
        end
      end

      context 'with parameter instruction_cache_size' do
        let(:params) do
          { instruction_cache_size: '1103' }
        end

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        case osver
        when 'Ubuntu-14.04'
          it {
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-i 1103"})
          }

        when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
             'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
          it {
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -i 1103})
          }
        end
      end

      context 'with parameter write_wakeup_threshold' do
        let(:params) do
          { write_wakeup_threshold: '1103' }
        end

        osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
        osver = "#{facts[:operatingsystem]}-#{osrel}"

        case osver
        when 'Ubuntu-14.04'
          it {
            is_expected.to contain_file('/etc/default/haveged') \
              .with_content(%r{^DAEMON_ARGS="-w 1103"$})
          }

        when 'Debian-8', 'Debian-9', 'Ubuntu-16.04', 'Ubuntu-18.04',
             'Scientific-7', 'CentOS-7', 'RedHat-7', 'OracleLinux-7'
          it {
            is_expected.to contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(%r{^ExecStart=.*haveged --Foreground --verbose=1 -w 1103$})
          }
        end
      end
    end
  end
end
