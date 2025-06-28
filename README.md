# haveged

[![Build Status](https://github.com/smoeding/puppet-haveged/actions/workflows/CI.yaml/badge.svg)](https://github.com/smoeding/puppet-haveged/actions/workflows/CI.yaml)
[![Puppet Forge](http://img.shields.io/puppetforge/v/stm/haveged.svg)](https://forge.puppetlabs.com/stm/haveged)
[![OpenVox](https://img.shields.io/badge/OpenVox-orange?label=Tested%20on)](https://voxpupuli.org/openvox/)
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

* On Debian based systems this includes the `/etc/default/haveged` file.

* On RedHat based systems the configuration is stored in the `/etc/systemd/system/haveged.service.d/opts.conf` file.

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
  write_wakeup_threshold => 2048,
}
```

## Reference

See [REFERENCE.md](https://github.com/smoeding/puppet-haveged/blob/master/REFERENCE.md) for the reference documentation.

## Development

Feel free to send pull requests for new features and other operating systems.
