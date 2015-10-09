require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :osfamily                 => 'Debian',
    :operatingsystem          => 'Debian',
    :haveged_startup_provider => 'init',
  }
end

at_exit { RSpec::Puppet::Coverage::report! }
