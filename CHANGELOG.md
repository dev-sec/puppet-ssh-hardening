# Changelog

## 1.0.5

* feature: UsePrivilegeSeparation = sandbox for ssh >= 5.9
* feature: support Puppet 4

## 1.0.4

* improvement: reprioritize EtM-based MACs
* improvement: move SHA1 KEX algos from default to weak profile

## 1.0.3

* feature: remove legacy SSHv1 code
* feature: add back GCM cipher

## 1.0.2

* bugfix: pass allow_{tcp,agent}_forwarding from init to classes

## 1.0.1

* feature: add back puppet 3.4.3 support
* feature: make other SSH configuration options configurable
* improvement: added faq on locked accounts to readme

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
