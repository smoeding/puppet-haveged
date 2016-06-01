require 'spec_helper'

describe 'haveged::config' do

  on_supported_os.each do |os, facts|

    osrel = facts[:operatingsystemmajrelease] || facts[:operatingsystemrelease]
    osver = "#{facts[:operatingsystem]}-#{osrel}"

    context "on #{os} with default parameters" do
      case osver
      when 'Debian-6', 'Debian-7',
           'Ubuntu-12.04', 'Ubuntu-14.04', 'Ubuntu-15.04'
        let(:facts) { facts.merge({ :haveged_startup_provider => 'init' }) }

        it {
          should contain_file('/etc/default/haveged') \
                  .with_ensure('file') \
                  .with_owner('root') \
                  .with_group('root') \
                  .with_mode('0644') \
                  .with_content(/^DAEMON_ARGS=""/)

          should_not contain_file('/etc/systemd/system/haveged.service.d')
          should_not contain_file('/etc/systemd/system/haveged.service.d/opts.conf')
        }

      when 'Debian-8'
        let(:facts) { facts.merge({ :haveged_startup_provider => 'systemd' }) }

      when 'Scientific-6', 'CentOS-6', 'RedHat-6'
        let(:facts) { facts.merge({ :haveged_startup_provider => 'init' }) }

      when 'OracleLinux-6'
        # This is not supported by the facts helper yet
        let(:facts) {
          facts.merge({
            :haveged_startup_provider => 'init',
            :osfamily => 'RedHat'
          })
        }

      when 'Scientific-7', 'CentOS-7', 'RedHat-7'
        let(:facts) { facts.merge({ :haveged_startup_provider => 'systemd' }) }

      when 'OracleLinux-7'
        # This is not supported by the facts helper yet
        let(:facts) {
          facts.merge({
            :haveged_startup_provider => 'systemd',
            :osfamily => 'RedHat'
          })
        }

        it {
          should contain_file('/etc/systemd/system/haveged.service.d') \
                  .with_ensure('directory') \
                  .with_owner('root') \
                  .with_group('root') \
                  .with_mode('0644')

          should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
                  .with_ensure('file') \
                  .with_owner('root') \
                  .with_group('root') \
                  .with_mode('0644') \
                  .with_content(/^ExecStart=.*haveged --Foreground --verbose=1/)

          should_not contain_file('/etc/default/haveged')
        }

      else
        # fail if actual os is not tested here
        it { expect('osver').to eq(osver) }
      end
    end
  end

  context 'using init startup with parameter buffer_size' do
    let :facts  do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-b 1103"/)
    }
  end

  context 'using systemd startup with parameter buffer_size' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :buffer_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -b 1103/)
    }
  end

  context 'using init startup with parameter data_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-d 1103"/)
    }
  end

  context 'using systemd startup with parameter data_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :data_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -d 1103/)
    }
  end

  context 'using init startup with parameter instruction_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-i 1103"/)
    }
  end

  context 'using systemd startup with parameter instruction_cache_size' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :instruction_cache_size => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -i 1103/)
    }
  end

  context 'using init startup with parameter write_wakeup_threshold' do
    let :facts do
      { :haveged_startup_provider => 'init' }
    end

    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_file('/etc/default/haveged') \
              .with_content(/^DAEMON_ARGS="-w 1103"$/)
    }
  end

  context 'using systemd startup with parameter write_wakeup_threshold' do
    let :facts do
      { :haveged_startup_provider => 'systemd' }
    end

    let :params do
      { :write_wakeup_threshold => '1103' }
    end

    it {
      should contain_file('/etc/systemd/system/haveged.service.d/opts.conf') \
              .with_content(/^ExecStart=.*haveged --Foreground --verbose=1 -w 1103$/)
    }
  end
end
