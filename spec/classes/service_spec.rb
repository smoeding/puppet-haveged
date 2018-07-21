require 'spec_helper'

describe 'haveged::service' do
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
          is_expected.to contain_service('haveged') \
            .with_ensure('running') \
            .with_enable('true') \
            .with_name('haveged')
        }
      end

      context 'with defined parameters' do
        let :params do
          {
            service_name:   'foobar',
            service_enable: 'foo',
            service_ensure: 'bar',
          }
        end

        it {
          is_expected.to contain_service('haveged') \
            .with_ensure('bar') \
            .with_enable('foo') \
            .with_name('foobar')
        }
      end
    end
  end
end
