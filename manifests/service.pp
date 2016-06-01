# = Class: haveged::service
#
# Manage the haveged service
#
# == Parameters:
#
# [*service_name*]
#   The name of the service to manage.
#
# [*service_ensure*]
#   Whether the service should be running.
#
# [*service_enable*]
#   Whether the service should be enabled to start at boot time.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'haveged::service': }
#
#
class haveged::service (
  $service_name   = defined('$::haveged::service_name') ? { true => getvar('::haveged::service_name'), default => $::haveged::params::service_name },
  $service_ensure = defined('$::haveged::_service_ensure') ? { true => getvar('::haveged::_service_ensure'), default => 'running' },
  $service_enable = defined('$::haveged::_service_enable') ? { true => getvar('::haveged::_service_enable'), default => true }
) inherits ::haveged::params {

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable
  }
}
