require 'spec_helper'

describe 'haveged::package' do
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
  end
end
