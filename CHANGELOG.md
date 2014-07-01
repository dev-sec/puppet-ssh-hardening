# Changelog

## 1.0.0

* feature: add support for oracle linux in crypto
* feature: add configurable agent and tcp forwarding
* feature: add kex configuration for redhat and centos
* feature: add mac configuration for redhat and centos
* feature: add cipher configuration for redhat and centos
* feature: implemented cipher detection for ubuntu 12.04 and 14.04
* feature: implemented mac detection for ubuntu 12.04 and 14.04
* feature: implemented kex detection for ubuntu 12.04 and 14.04
* feature: make crypto configuration conditional on the OS
* bugfix: dont set `undef` values in ssh client config

## 0.1.1

* improvement: add kitchen tests (pre-release)
* improvement: puppet-lint fixes
* bugfix: adjust client ciphers to working set
* bugfix: correct string concatenantions
* bugfix: mac -> macs

## 0.1.0

Initial release
