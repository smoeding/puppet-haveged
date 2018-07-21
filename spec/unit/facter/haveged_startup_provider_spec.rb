require 'spec_helper'

describe 'Facter::Util::Fact' do
  subject { Facter.fact(:haveged_startup_provider).value }

  before(:each) do
    Facter.clear
    Facter.fact(:kernel).stub(:value) { 'Linux' }
  end

  context 'haveged_startup_provider with /proc/1/comm' do
    before(:each) do
      allow(File).to receive(:open).and_return("foo\n")
    end

    it { is_expected.to eq('foo') }
  end

  context 'haveged_startup_provider without /proc/1/comm' do
    before(:each) do
      allow(File).to receive(:open).and_raise(StandardError)
    end

    it { is_expected.to eq('init') }
  end
end
