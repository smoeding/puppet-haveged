# = Class: haveged::package
#
# Manage the haveged package
#
# == Parameters:
#
# [*package_name*]
#   The name of the package to manage.
#
# [*package_ensure*]
#   Ensure parameter passed onto Package resources.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'haveged::package':
#     package_name   => 'haveged',
#     package_ensure => installed,
#   }
#
#
class haveged::package (
  $package_name   = $::haveged::params::package_name,
  $package_ensure = installed,
) inherits ::haveged::params {

  package { 'haveged':
    ensure => $package_ensure,
    name   => $package_name,
  }
}
