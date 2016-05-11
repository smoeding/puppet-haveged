require "spec_helper"

describe 'Facter::Util::Fact' do
  before {
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns("Linux")
  }
  after {
    Facter.clear
  }

  describe 'haveged_startup_provider with /proc/1/comm' do
    it {
      File.stubs(:open).returns("foo\n")
      expect(Facter.fact(:haveged_startup_provider).value).to eq('foo')
    }
  end

  describe 'haveged_startup_provider without /proc/1/comm' do
    it {
      File.stubs(:open) { raise(StandardException) }
      expect(Facter.fact(:haveged_startup_provider).value).to eq('init')
    }
  end
end
