require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

RSpec.configure do |c|
  c.default_facts = {
    :osfamily                 => 'Debian',
    :operatingsystem          => 'Debian',
    :haveged_startup_provider => 'init',
  }
end

at_exit { RSpec::Puppet::Coverage::report! }
