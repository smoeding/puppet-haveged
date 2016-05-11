# haveged

[![Build Status](https://travis-ci.org/smoeding/puppet-haveged.svg?branch=master)](https://travis-ci.org/smoeding/puppet-haveged)
[![Puppet Forge](http://img.shields.io/puppetforge/v/stm/haveged.svg)](https://forge.puppetlabs.com/stm/haveged)
[![License](https://img.shields.io/github/license/smoeding/puppet-haveged.svg)](https://raw.githubusercontent.com/smoeding/puppet-haveged/master/LICENSE)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with haveged](#setup)
	* [What haveged affects](#what-haveged-affects)
	* [Setup requirements](#setup-requirements)
	* [Beginning with haveged](#beginning-with-haveged)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Install and manage the haveged daemon.

## Module Description

The haveged daemon provides a random number generator based on the HAVEGE (HArdware Volatile Entropy Gathering and Expansion) algorithm. This module provides a way of installing and setting up the daemon in your environment.

## Setup

### What haveged affects

Package, service and configuration files for the haveged daemon.

* On Debian based systems this includes the `/etc/default/haveged` file if an `init` based startup system is used. For systems using `systemd` the configuration is stored in the `/etc/systemd/system/haveged.service.d/opts.conf` file.

* On RHEL 6 systems the configuration is unfortunately hardcoded and no configuration file is used.

* On RHEL 7 systems the configuration is stored in the `/etc/systemd/system/haveged.service.d/opts.conf` file.

### Setup Requirements

The haveged module requires the Puppetlabs modules `stdlib`.

The `haveged` package is part of the EPEL yum repository, so this must be enabled on Enterprise Linux.

### Beginning with haveged

Declare the haveged class to install and run the haveged daemon with the default parameters.

```puppet
class { 'haveged': }
```

This installs the haveged package and starts the service.

See the next sections for a detailed description of the available configuration options.

## Usage

### Use a higher threshold of available entropy

```puppet
class { 'haveged':
  write_wakeup_threshold => '2048',
}
```

## Reference

### Classes

#### Public Classes

* `haveged`: The basic setup of the haveged daemon.

#### Private Classes

* `haveged::config`: Configures the haveged daemon by updating the run time parameters for the daemon.
* `haveged::package`: Installs the package.
* `haveged::params`: Manages the parameters
* `haveged::service`: Manages the haveged daemon.

#### Class: `haveged`

Main class, includes all other classes.

##### Parameters (all optional)

* `buffer_size`: Configure the collection buffer size. The value must be a string with a numeric value. It is interpreted as size in KB. Default: '128'

* `data_cache_size`: Set the data cache size. The value must be string with a numeric value. It is interpreted as size in KB. The default is '16' or as determined by the CPUID.

* `instruction_cache_size`: Set the instruction cache size. The value must be string with a numeric value. It is interpreted as size in KB. The default is '16'* or as determined by the CPUID.

* `write_wakeup_threshold`: Configure the threshold of available entropy. The daemon tries to keep the amount of available entropy below this amount of bits. The value must be string with a numeric value. Default: '1024'

* `service_name`: The name of the service to manage. Normally provided by the `haveged::params` class.

* `service_enable`: Whether the haveged service should be enabled to start at boot. Valued options: 'true', 'false'. Default: 'true'

* `service_ensure`: Whether the haveged service should be running. Valid options: 'stopped', 'false', 'running', 'true'. Default: 'running'

* `package_name`: The name of the package to manage. Normally provided by the `haveged::params` class.

* `package_ensure`: The state of the haveged package. Valid options: 'present', 'installed', 'absent', 'purged', 'held', 'latest' or a specific package version number. Default: 'present'

### Facts

This module provides the following facts:

* `haveged_startup_provider`: The startup system used on the node. The value of the fact can either be `systemd` or `init`.

## Limitations

Unfortunately the configuration is hardcoded on RHEL 6 systems. Using class parameters to set specific options will have no effect.

The `haveged` module has been tested on

* Debian 6 (Squeeze)
* Debian 7 (Wheezy)
* Debian 8 (Jessie)
* Ubuntu 12.04 (Precise Pangolin)
* Ubuntu 14.04 (Trusty Tahr)
* Ubuntu 15.04 (Vivid Vervet)
* CentOS 6
* CentOS 7

## Development

Feel free to send pull requests for new features and other operating systems.
