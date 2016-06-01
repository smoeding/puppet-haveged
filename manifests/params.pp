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

  case $::osfamily {
    'Debian': {
      $package_name = 'haveged'
      $service_name = 'haveged'

      case getvar('::haveged_startup_provider') {
        'init': {
          $daemon_opts_file = '/etc/default/haveged'
          $systemd_opts_dir = undef
        }
        'systemd': {
          $daemon_opts_file = undef
          $systemd_opts_dir = "/etc/systemd/system/${service_name}.service.d"
        }
        default: {
          fail("Unrecognized startup system '${::haveged_startup_provider}'")
        }
      }
    }
    'RedHat': {
      $package_name = 'haveged'
      $service_name = 'haveged'

      case getvar('::haveged_startup_provider') {
        'init': {
          $daemon_opts_file = undef
          $systemd_opts_dir = undef
        }
        'systemd': {
          $daemon_opts_file = undef
          $systemd_opts_dir = "/etc/systemd/system/${service_name}.service.d"
        }
        default: {
          fail("Unrecognized startup system '${::haveged_startup_provider}'")
        }
      }
    }
    default: {
      fail("Unsupported osfamily '${::osfamily}'")
    }
  }
}
