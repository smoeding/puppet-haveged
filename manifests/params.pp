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
    'Debian', 'Ubuntu': {
      $package_name = 'haveged'
      $service_name = 'haveged'

      $daemon_options_file = '/etc/default/haveged'
      $daemon_options_args = 'DAEMON_ARGS'
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }
}
