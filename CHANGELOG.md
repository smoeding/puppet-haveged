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
