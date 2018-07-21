require 'spec_helper'

describe 'Facter::Util::Fact' do
  each(:before) do
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns('Linux')
  end

  each(:after) do
    Facter.clear
  end

  context 'haveged_startup_provider with /proc/1/comm' do
    it {
      File.stubs(:open).returns("foo\n")
      expect(Facter.fact(:haveged_startup_provider).value).to eq('foo')
    }
  end

  context 'haveged_startup_provider without /proc/1/comm' do
    it {
      File.stubs(:open) { raise(StandardException) }
      expect(Facter.fact(:haveged_startup_provider).value).to eq('init')
    }
  end
end
