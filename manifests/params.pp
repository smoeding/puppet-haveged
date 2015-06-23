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

      # shell configuration
      $daemon_options_file = '/etc/default/haveged'
      $daemon_options_args = 'DAEMON_ARGS'

      # systemd configuration
      $systemd_base = undef
      $systemd_options_dir = undef
    }
    'CentOS', 'RedHat': {
      $package_name = 'haveged'
      $service_name = 'haveged'

      # shell configuration
      $daemon_options_file = undef
      $daemon_options_args = undef

      # systemd configuration
      $systemd_base = '/etc/systemd/system/'
      $systemd_options_dir = "${systemd_base}/${service_name}.service.d"
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }
}
