# haveged

[![Build Status](https://travis-ci.org/smoeding/puppet-haveged.svg?branch=master)](https://travis-ci.org/smoeding/puppet-haveged)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
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

## Setup

### What haveged affects

### Setup Requirements

The haveged module requires the Puppetlabs modules `stdlib`.

### Beginning with haveged

Declare the haveged class to install and run the haveged daemon with the default parameters.

```puppet
class { '::haveged': }
```

This installs the haveged package and starts the service.

See the next sections for a detailed description of the available configuration options.

## Usage

## Reference

### Classes

#### Public Classes

* `class haveged`

#### Private Classes

* `class haveged::config`
* `class haveged::package`
* `class haveged::params`
* `class haveged::service`

## Limitations

The haveged package is currently developed and tested on Debian 7 (Wheezy). More supported operating systems are planned in future releases.

## Development

Feel free to send pull requests for new features.
