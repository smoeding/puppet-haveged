require 'spec_helper'
require 'facter/haveged_startup_provider'

describe 'haveged_startup_provider', type: :fact do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  context 'when haveged_startup_provider with /proc/1/comm' do
    before(:each) do
      allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
      allow(File).to receive(:open).and_call_original
      allow(File).to receive(:open).with('/proc/1/comm').and_return("foo\n")
    end

    it {
      expect(Facter.fact(:haveged_startup_provider).value).to eq('foo')
    }
  end

  context 'when haveged_startup_provider without /proc/1/comm' do
    before(:each) do
      allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
      allow(File).to receive(:open).and_call_original
      allow(File).to receive(:open).with('/proc/1/comm').and_raise(StandardError)
    end

    it {
      expect(Facter.fact(:haveged_startup_provider).value).to eq('init')
    }
  end
end
