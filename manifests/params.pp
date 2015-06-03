# = Class: haveged::params
#
# Manage operating system specific parameters for haveged
#
# == Parameters:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'haveged::params': }
#
#
class haveged::params {

  case $::operatingsystem {
    'Debian': {
      $package_name = 'haveged'
      $service_name = 'haveged'
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }
}
