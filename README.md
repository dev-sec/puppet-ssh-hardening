# ssh_hardening (Puppet module)

## Description

This module provides secure ssh-client and ssh-server configurations.

## Requirements

* Puppet
* Puppet modules: `saz/ssh`


## Parameters

* `ipv5_enabled` - true if IPv6 is needed
* `cbc_required` - true if CBC for ciphers is required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure ciphers enabled. CBC is a weak alternative. Anything weaker should be avoided and is thus not available.
* `weak_hmac` - true if weaker HMAC mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure HMACs enabled.
* `weak_kex` - true if weaker Key-Exchange (KEX) mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure KEXs enabled.
* `allow_root_with_key` - `false` to disable root login altogether. Set to `true` to allow root to login via key-based mechanism.
* `ports` - ports to which ssh-server should listen to and ssh-client should connect to
* `listen_to` - one or more ip addresses, to which ssh-server should listen to. Default is empty, but should be configured for security reasons!
* `remote_hosts` - one or more hosts, to which ssh-client can connect to. Default is empty, but should be configured for security reasons!

## Usage

After adding this module, you can use the class:

    class { 'ssh_hardening': }

This will install ssh-server and ssh-client. You can alternatively choose only one via:

    class { 'ssh_hardening::server': }
    class { 'ssh_hardening::client': }

You should configure core attributes:

    class { 'ssh_hardening::server':
      "listen_to" : ["10.2.3.4"]
    }

**The default value for `listen_to` is `0.0.0.0`. It is highly recommended to change the value.**


## Contributors + Kudos

...

## License and Author

* Author:: Dominik Richter <dominik.richter@googlemail.com>
* Author:: Deutsche Telekom AG

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
