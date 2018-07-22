# init.pp --- Class haveged
#
# @summary Manage the haveged daemon
#
# @example Declaring the class
#
#   class { 'haveged':
#     write_wakeup_threshold => 2048,
#   }
#
# @param buffer_size
#   The size of the collection buffer. The value must be a an integer.
#   It is interpreted as size in KB. Default: 128
#
# @param data_cache_size
#   The data cache size in KB. The value must be a an integer.Default is 16
#   or as determined by cpuid.
#
# @param instruction_cache_size
#   The instruction cache size in KB. The value must be a an integer.Default
#   is 16 or as determined by cpuid.
#
# @param write_wakeup_threshold
#   The haveged daemon generates more data if the number of entropy bits
#   falls below this value. The value must be a an integer. Default: 1024
#
# @param service_name
#   The name of the service to manage. Default: 'haveged'
#
# @param service_ensure
#   Whether the service should be running. Default: 'running'
#
# @param service_enable
#   Whether the service should be enabled to start at boot time. This must be
#   an boolean value: Default: true
#
# @param package_name
#   The name of the package to manage. Default: 'haveged'
#
# @param package_ensure
#   Ensure parameter passed onto Package resources. Default: 'present'
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
