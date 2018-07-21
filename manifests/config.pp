# = Class: haveged::config
#
# Manage the haveged configuration file
#
# == Parameters:
#
# [*buffer_size*]
#   The size of the collection buffer in KB.
#
# [*data_cache_size*]
#   The data cache size in KB.
#
# [*instruction_cache_size*]
#   The instruction cache size in KB.
#
# [*write_wakeup_threshold*]
#   The haveged daemon generates more data if the number of entropy bits
#   falls below this value.
#
# == Requires:
#
# Puppetlabs stdlib module.
#
# == Sample Usage:
#
#   class { 'haveged::config': }
#
#
class haveged::config (
  Optional[Integer]              $buffer_size            = undef,
  Optional[Integer]              $data_cache_size        = undef,
  Optional[Integer]              $instruction_cache_size = undef,
  Optional[Integer]              $write_wakeup_threshold = undef,
  Optional[Stdlib::Absolutepath] $daemon_opts_file       = $::haveged::params::daemon_opts_file,
  Optional[Stdlib::Absolutepath] $systemd_opts_dir       = $::haveged::params::systemd_opts_dir,
) inherits haveged::params {

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
  if $daemon_opts_file {
    file { $daemon_opts_file:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('haveged/default.epp', { 'opts' => $opts }),
    }
  }

  # Update systemd configuration file if applicable
  if $systemd_opts_dir {
    file { $systemd_opts_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { "${systemd_opts_dir}/opts.conf":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('haveged/systemd.epp', { 'opts' => $opts }),
    }
  }
}
