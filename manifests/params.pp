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
      $provider = $::operatingsystemmajrelease ? {
        '6'     => 'init',
        '7'     => 'init',
        '8'     => 'systemd',
        default => undef,
      }
    }
    'Ubuntu': {
      $provider = $::operatingsystemrelease ? {
        '14.04' => 'systemd',
        default => undef,
      }
    }
    'CentOS', 'RedHat': {
      $provider = $::operatingsystemrelease ? {
        '7'     => 'systemd',
        default => undef,
      }
    }
  }

  validate_re($provider, [ '^init$', '^systemd$' ], "Unsupported operatingsystem ${::operatingsystem} or release")

  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $package_name = 'haveged'
      $service_name = 'haveged'

      case $provider {
        'init': {
          $daemon_opts_file = '/etc/default/haveged'
          $daemon_opts_args = 'DAEMON_ARGS'
          $systemd_opts_dir = undef
          $systemd_template = undef
        }
        'systemd': {
          $daemon_opts_file = undef
          $daemon_opts_args = undef
          $systemd_opts_dir = "/etc/systemd/system/${service_name}.service.d"
          $systemd_template = undef
        }
        default: {
          fail("Unsupported provider ${provider} on ${::operatingsystem}")
        }
      }
    }
    'CentOS', 'RedHat': {
      $package_name = 'haveged'
      $service_name = 'haveged'

      case $provider {
        'init': {
          $daemon_opts_file = undef
          $daemon_opts_args = undef
          $systemd_opts_dir = undef
          $systemd_template = undef
        }
        'systemd': {
          $daemon_opts_file = undef
          $daemon_opts_args = undef
          $systemd_opts_dir = "/etc/systemd/system/${service_name}.service.d"
          $systemd_template = undef
        }
        default: {
          fail("Unsupported provider ${provider} on ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }
}
