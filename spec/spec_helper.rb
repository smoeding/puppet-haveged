require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :osfamily                  => 'Debian',
    :operatingsystem           => 'Debian',
    :operatingsystemmajrelease => '7',
  }
end

at_exit { RSpec::Puppet::Coverage::report! }
