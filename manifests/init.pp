# = Class: haveged
#
# Manage haveged
#
# == Parameters:
#
# [*buffer_size*]
#   The size of the collection buffer in KB. Default: 128
#
# [*data_cache_size*]
#   The data cache size in KB. Default is 16 or as determined by cpuid.
#
# [*instruction_cache_size*]
#   The instruction cache size in KB. Default is 16 or as determined by cpuid.
#
# [*write_wakeup_threshold*]
#   The haveged daemon generates more data if the number of entropy bits
#   falls below this value.
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
# [*package_name*]
#   The name of the package to manage.
#
# [*package_ensure*]
#   Ensure parameter passed onto Package resources.
#
# == Requires:
#
# Augeas bindings for Puppet. Puppetlabs stdlib module.
#
# == Sample Usage:
#
#   class { 'haveged':
#     write_wakeup_threshold => 1024,
#   }
#
#
class haveged (
  $buffer_size            = undef,
  $data_cache_size        = undef,
  $instruction_cache_size = undef,
  $write_wakeup_threshold = '1024',
  $service_name           = $::haveged::params::service_name,
  $service_enable         = true,
  $service_ensure         = running,
  $package_name           = $::haveged::params::package_name,
  $package_ensure         = installed,
) inherits ::haveged::params {

  # Validate numeric values
  if ($buffer_size != undef) {
    validate_re($buffer_size, '^[0-9]+$')
  }
  if ($data_cache_size != undef) {
    validate_re($data_cache_size, '^[0-9]+$')
  }
  if ($instruction_cache_size != undef) {
    validate_re($instruction_cache_size, '^[0-9]+$')
  }
  if ($write_wakeup_threshold != undef) {
    validate_re($write_wakeup_threshold, '^[0-9]+$')
  }

  anchor { '::haveged::begin': }

  class { '::haveged::package':
    package_name   => $package_name,
    package_ensure => $package_ensure,
    require        => Anchor['::haveged::begin'],
  }

  if ($service_ensure in [ true, running ]) {
    class { '::haveged::config':
      buffer_size            => $buffer_size,
      data_cache_size        => $data_cache_size,
      instruction_cache_size => $instruction_cache_size,
      write_wakeup_threshold => $write_wakeup_threshold,
      require                => Class['::haveged::package'],
      notify                 => Class['::haveged::service'],
    }
  }
  else {
    # Allow stopping before removal
    Class['::haveged::service'] -> Class['::haveged::package']
  }

  class { '::haveged::service':
    service_name   => $service_name,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    before         => Anchor['::haveged::end'],
  }

  anchor { '::haveged::end': }
}
