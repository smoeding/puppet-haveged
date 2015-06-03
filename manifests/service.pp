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
  $service_name   = $::haveged::params::service_name,
  $service_ensure = running,
  $service_enable = true,
) inherits ::haveged::params {

  service { 'haveged':
    ensure => $service_ensure,
    enable => $service_enable,
    name   => $service_name,
  }
}
