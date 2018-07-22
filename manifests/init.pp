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
#     write_wakeup_threshold => 2048,
#   }
#
#
class haveged (
  String                         $package_name,
  String                         $package_ensure,
  String                         $service_name,
  Boolean                        $service_enable,
  Stdlib::Ensure::Service        $service_ensure,
  Integer                        $write_wakeup_threshold,
  Optional[Integer]              $buffer_size            = undef,
  Optional[Integer]              $data_cache_size        = undef,
  Optional[Integer]              $instruction_cache_size = undef,
  Optional[Stdlib::Absolutepath] $daemon_opts            = undef,
  Optional[Stdlib::Absolutepath] $systemd_dir            = undef,
) {

  package { 'haveged':
    ensure => $package_ensure,
    name   => $package_name,
  }

  unless ($package_ensure in ['absent', 'purged', ]) {
    # Combine all daemon options
    $opts_hash = {
      '-b' => $buffer_size,
      '-d' => $data_cache_size,
      '-i' => $instruction_cache_size,
      '-w' => $write_wakeup_threshold,
    }

    # Remove all entries where the value is 'undef'
    $opts_ok = delete_undef_values($opts_hash)

    # Concat key and value into array elements
    $opts_strings = join_keys_to_values($opts_ok, ' ')

    # Join array elements into one string
    $opts = join($opts_strings, ' ')

    # Update shell configuration file if applicable
    if $daemon_opts {
      file { $daemon_opts:
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp('haveged/default.epp', { 'opts' => $opts }),
        require => Package['haveged'],
        notify  => Service['haveged'],
      }
    }

    # Update systemd configuration file if applicable
    if $systemd_dir {
      file { "${systemd_dir}/${service_name}.service.d":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      file { "${systemd_dir}/${service_name}.service.d/opts.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp('haveged/systemd.epp', { 'opts' => $opts }),
        require => Package['haveged'],
        notify  => Service['haveged'],
      }
    }

    Service { 'haveged':
      ensure => $service_ensure,
      enable => $service_enable,
      name   => $service_name,
    }
  }
}
