require 'spec_helper'

describe 'haveged' do

  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with default parameters" do
      it {
        should contain_class('haveged')

        should contain_class('haveged::params')

        should contain_anchor('haveged::begin')
        should contain_anchor('haveged::end')

        should contain_class('haveged::package') \
                .that_requires('Anchor[haveged::begin]')

        should contain_class('haveged::config') \
                .with_write_wakeup_threshold('1024') \
                .that_requires('Class[haveged::package]') \
                .that_notifies('Class[haveged::service]')

        should contain_class('haveged::service') \
                .that_comes_before('Anchor[haveged::end]')
      }
    end

    context "on #{os} with service_ensure => stopped" do
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

    context "on #{os} with package parameters defined" do
      let :params do
        {
          :package_name   => 'foobar',
          :package_ensure => 'foo'
        }
      end

      it {
        should contain_class('haveged::package') \
                .with_package_name('foobar') \
                .with_package_ensure('foo')
      }
    end

    context "on #{os} with service parameters defined" do
      let :params do
        {
          :service_name   => 'foobar',
          :service_enable => 'foo',
          :service_ensure => 'bar',
        }
      end

      it {
        should contain_class('haveged::service') \
                .with_service_name('foobar') \
                .with_service_enable('foo') \
                .with_service_ensure('bar')
      }
    end

    context "on #{os} with config parameters defined" do
      let :params do
        {
          :buffer_size            => '2',
          :data_cache_size        => '3',
          :instruction_cache_size => '5',
          :write_wakeup_threshold => '7',

        }
      end

      it {
        should contain_class('haveged::config') \
                .with_buffer_size('2') \
                .with_data_cache_size('3') \
                .with_instruction_cache_size('5') \
                .with_write_wakeup_threshold('7')
      }
    end

    context "on #{os} with package_ensure => true" do
      let :params do
        {
          :package_ensure => true
        }
      end

      it {
        should contain_class('haveged::package') \
                .with_package_ensure('present')

        should contain_class('haveged::config') \
                .that_requires('Class[haveged::package]') \
                .that_notifies('Class[haveged::service]')

        should contain_class('haveged::config')

        should contain_class('haveged::service') \
                .with_service_ensure('running')
      }
    end

    context "on #{os} with package_ensure => false" do
      let :params do
        {
          :package_ensure => false
        }
      end

      it {
        should contain_class('haveged::package') \
                .with_package_ensure('purged')

        should contain_class('haveged::service') \
                .with_service_ensure('stopped') \
                .that_comes_before('Class[haveged::package]')
      }
    end

    context "on #{os} with package_ensure => absent" do
      let :params do
        {
          :package_ensure => 'absent'
        }
      end

      it {
        should contain_class('haveged::package') \
                .with_package_ensure('purged')

        should contain_class('haveged::service') \
                .with_service_ensure('stopped') \
                .that_comes_before('Class[haveged::package]')
      }
    end

    context "on #{os} with package_ensure => purged" do
      let :params do
        {
          :package_ensure => 'purged'
        }
      end

      it {
        should contain_class('haveged::package') \
                .with_package_ensure('purged')

        should contain_class('haveged::service') \
                .with_service_ensure('stopped') \
                .that_comes_before('Class[haveged::package]')
      }
    end
  end

  context 'on an unsupported operating system' do
    let :facts do
      { :osfamily => 'VMS', :operatingsystem => 'VAX/VMS' }
    end

    it { is_expected.to raise_error Puppet::Error, /Unsupported osfamily VMS/ }
  end
end
