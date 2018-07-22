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

This module requires the `stdlib` module.

The `haveged` package is part of the EPEL yum repository, so this repository must be enabled on Enterprise Linux to be able to install the package.

### Beginning with haveged

Declare the haveged class to run the haveged daemon with the default parameters.

```puppet
class { 'haveged': }
```

This installs the haveged package and starts the service using default parameters.

See the following sections for a detailed description of the available configuration options.

## Usage

### Use a higher threshold of available entropy

```puppet
class { 'haveged':
  write_wakeup_threshold => '2048',
}
```

## Reference

- [**Public Classes**](#public-classes)
  - [Class: haveged](#class-haveged)
- [**Facts**](#facts)
  - [Fact: haveged_startup_provider](#fact-haveged_startup_provider)

### Public Classes

#### Class: `haveged`

Main class, includes all other classes.

**Parameters for the `haveged` class:**

##### `buffer_size`

Configure the collection buffer size. The value must be a an integer value. It is interpreted as size in KB. Default: `128`

##### `data_cache_size`

Set the data cache size. The value must be an integer value. It is interpreted as size in KB. The default is `16`

##### `instruction_cache_size`

Set the instruction cache size. The value must be an integer value. It is interpreted as size in KB. The default is `16` or as determined by the CPUID.

##### `write_wakeup_threshold`

Configure the threshold of available entropy. The daemon tries to keep the amount of available entropy above this amount of bits. The value must be an integer value. Default: `1024`

##### `service_name`

The name of the service to manage. Normally provided by the module's hiera configuration.

##### `service_enable`

Whether the haveged service should be enabled to start at boot. Valid options: `true`, `false`. Default: `true`

##### `service_ensure`

Whether the haveged service should be running. Valid options: `stopped`, `false`, `running`, `true`. Default: `running`

##### `package_name`

The name of the package to manage. Normally provided by the module's hiera configuration.

##### `package_ensure`

The state of the haveged package. Valid options: `present`, `installed`, `absent`, `purged`, `held`, `latest` or a specific package version number. Default: `present`

### Facts

This module provides the following facts.

##### Fact: `haveged_startup_provider`

The startup system used on the node. The implementation uses the process name of PID 1 to resolve the fact. The value is either `systemd` or `init`.

## Limitations

The `haveged` module has been tested on

* Debian 8 (Jessie)
* Debian 9 (Stretch)
* Ubuntu 14.04 (Trusty Tahr)
* Ubuntu 16.04 (Xenial Xerus)
* Ubuntu 18.04 (Bionic Beaver)
* CentOS 6
* CentOS 7

> Unfortunately the configuration is hardcoded on RHEL 6 systems. Using class parameters to set specific options will have no effect.

## Development

Feel free to send pull requests for new features and other operating systems.
