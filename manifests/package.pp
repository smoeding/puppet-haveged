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
#   Ensure parameter passed onto Package resources. Default: 'present'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'haveged::package':
#     package_name   => 'haveged',
#     package_ensure => 'present',
#   }
#
#
class haveged::package (
  $package_name   = defined('$::haveged::package_name') ? { true => getvar('::haveged::package_name'), default => $::haveged::params::package_name },
  $package_ensure = defined('$::haveged::_package_ensure') ? { true => getvar('::haveged::_package_ensure'), false => 'present' },
) inherits ::haveged::params {

  # Working around a bug in the package type
  # https://tickets.puppetlabs.com/browse/PUP-1295
  if ($::osfamily == 'RedHat') and ($package_ensure == 'purged') {
    $_package_ensure = 'absent'
  }
  else {
    $_package_ensure = $package_ensure
  }

  package { $package_name: ensure => $_package_ensure }
}
