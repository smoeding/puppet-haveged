require 'spec_helper'

describe 'Facter::Util::Fact' do
  context 'haveged_startup_provider with /proc/1/comm' do
    let(:facts) do
      { kernel: 'Linux' }
    end

    it {
      allow(File).to receive(:open).and_returns("foo\n")
      expect(Facter).to receive(:fact).with(:haveged_startup_provider).and_returns('foo')
    }
  end

  context 'haveged_startup_provider without /proc/1/comm' do
    let(:facts) do
      { kernel: 'Linux' }
    end

    it {
      allow(File).to receive(:open) { raise(StandardException) }
      expect(Facter).to receive(:fact).with(:haveged_startup_provider).and_returns('init')
    }
  end
end
