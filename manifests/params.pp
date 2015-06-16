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
    'CentOS', 'RedHat': {
      $package_name = 'haveged'
      $service_name = 'haveged'

      # No configuration file available
      $daemon_options_file = undef
      $daemon_options_args = undef
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }
}
