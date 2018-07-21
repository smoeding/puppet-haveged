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
#   Ensure parameter passed onto Package resources. Default: 'present'
#
# == Requires:
#
# Puppetlabs stdlib module.
#
# == Sample Usage:
#
#   class { 'haveged':
#     write_wakeup_threshold => 1024,
#   }
#
#
class haveged (
  String                                                 $package_name,
  Enum['present','installed','latest','absent','purged'] $package_ensure,
  String                                                 $service_name,
  Boolean                                                $service_enable,
  Stdlib::Ensure::Service                                $service_ensure,
  Integer                                                $write_wakeup_threshold,
  Optional[Integer]                                      $buffer_size            = undef,
  Optional[Integer]                                      $data_cache_size        = undef,
  Optional[Integer]                                      $instruction_cache_size = undef,
) inherits haveged::params {

  package { 'haveged':
    ensure => $package_ensure,
    name   => $package_name,
  }

  if ($package_ensure in ['present', 'installed', 'latest', ]) {
    class { 'haveged::config':
      buffer_size            => $buffer_size,
      data_cache_size        => $data_cache_size,
      instruction_cache_size => $instruction_cache_size,
      write_wakeup_threshold => $write_wakeup_threshold,
      require                => Package['haveged'],
      notify                 => Service['haveged'],
    }

    Service { 'haveged':
      ensure => $service_ensure,
      enable => $service_enable,
      name   => $service_name,
    }
  }
}
