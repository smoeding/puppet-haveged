## 2023-07-06 - Release 5.0.0

### Breaking changes

- Remove support for Puppet 6

### Enhancements

- Allow Stdlib 9.x
- Add support for Puppet 8

## 2023-02-05 - Release 4.0.0

### Breaking changes

- Remove support for CentOS and Scientific Linux
- Remove support for Debian 9 (EoL)

### Enhancements

- Add support for Ubuntu-22.04
- Add support for RedHat 9
- Add support for OracleLinux 9
- Allow systemd module 4.x

## 2021-09-29 - Release 3.0.1

### Enhancements

- Allow stdlib 8.x

## 2021-08-05 - Release 3.0.0

### Enhancements

- Add support for Debian 11
- Use the `puppet/systemd` module to manage the daemon.

### Breaking changes

- Remove support for Puppet 5
- Remove support for Enterprise Linux 6 (EoL)
- Remove support for Ubuntu 14.04 and 16.04 (EoL)

## 2020-10-28 - Release 2.1.0

### Enhancements

- Add Support for Debian 10
- Add Support for Ubuntu 20.04
- Add Support for RedHat 8
- Add Support for CentOS 8
- Add Support for OracleLinux 8

## 2019-09-27 - Release 2.0.0

### Breaking changes

- Remove support for Puppet 4.

### Enhancements

- Add support for Stdlib 6.x.

## 2019-02-17 - Release 1.1.0

### Summary

The module dependencies have been updated to include current releases of Puppet and the stdlib module.

## 2018-07-22 - Release 1.0.0

### Summary

This release is a complete rewrite of the module.

#### Breaking changes

- The module now uses data types to validate input parameters and therefore no longer works with Puppet 3.
- Numeric class parameters must now be integer values and can no longer be strings as in previous releases.
- Support for some older operating systems (Debian releases 6 & 7, Ubuntu 12.04) has been removed.

## 2015-10-11 - Release 0.2.0

### Summary

This release adds support for RedHat based systems.

#### Features

- Add `haveged_startup_provider` fact to check whether the node uses `init` or `systemd`.

## 2015-06-09 - Release 0.1.0

### Summary

Initial release.
