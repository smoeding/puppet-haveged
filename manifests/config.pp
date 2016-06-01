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
  $buffer_size            =  defined('$::haveged::buffer_size') ? { true => getvar('::haveged::buffer_size'), default => undef },
  $data_cache_size        =  defined('$::haveged::data_cache_size') ? { true => getvar('::haveged::data_cache_size'), default => undef },
  $instruction_cache_size =  defined('$::haveged::instruction_cache_size') ? { true => getvar('::haveged::instruction_cache_size'), default => undef },
  $write_wakeup_threshold =  defined('$::haveged::write_wakeup_threshold') ? { true => getvar('::haveged::write_wakeup_threshold'), default => undef }
) inherits ::haveged::params {

  # Validate numeric parameters
  if $buffer_size {
    validate_re($buffer_size, '^[0-9]+$')
  }
  if $data_cache_size {
    validate_re($data_cache_size, '^[0-9]+$')
  }
  if $instruction_cache_size {
    validate_re($instruction_cache_size, '^[0-9]+$')
  }
  if $write_wakeup_threshold {
    validate_re($write_wakeup_threshold, '^[0-9]+$')
  }

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
  $_daemon_opts_file = getvar('::haveged::params::daemon_opts_file')
  if $_daemon_opts_file {

    file { $_daemon_opts_file:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/default.erb"),
    }
  }

  # Update systemd configuration file if applicable
  $_systemd_opts_dir = getvar('::haveged::params::systemd_opts_dir')
  if ($_systemd_opts_dir != undef) {

    file { $_systemd_opts_dir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    file { "${_systemd_opts_dir}/opts.conf":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/systemd.erb"),
    }
  }
}
