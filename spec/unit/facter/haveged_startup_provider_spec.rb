require "spec_helper"

describe 'Facter::Util::Fact' do
  before {
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns("Linux")
  }
  after {
    Facter.clear
  }

  describe 'haveged_startup_provider' do
    it {
      File.stubs(:open).returns("foo\n")
      expect(Facter.fact(:haveged_startup_provider).value).to eq('foo')
    }
  end
end
