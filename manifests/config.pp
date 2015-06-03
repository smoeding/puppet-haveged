# = Class: haveged::config
#
# Manage the haveged configuration file
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
# == Requires:
#
# Augeas bindings for Puppet. Puppetlabs stdlib module.
#
# == Sample Usage:
#
#   class { 'haveged::config': }
#
#
class haveged::config (
  $buffer_size            = undef,
  $data_cache_size        = undef,
  $instruction_cache_size = undef,
  $write_wakeup_threshold = undef,
) {

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

  augeas { 'set-haveged-daemon_args':
    incl    => '/etc/default/haveged',
    lens    => 'Shellvars.lns',
    changes => "set DAEMON_ARGS '\"${opts}\"'",
  }
}
