# Puppet SSH hardening

[![Puppet Forge](https://img.shields.io/puppetforge/dt/hardening/ssh_hardening.svg)][1]
[![Build Status](http://img.shields.io/travis/hardening-io/puppet-ssh-hardening.svg)][2]
[![Gitter Chat](https://badges.gitter.im/Join%20Chat.svg)][3]

## Description

This Puppet module provides secure ssh-client and ssh-server configurations.

## Requirements

* Puppet
* Puppet modules: `saz/ssh` (>= 2.3.6), `puppetlabs/stdlib` (>= 4.2.0)


## Parameters

* `ipv6_enabled = false` - true if IPv6 is needed
* `cbc_required = false` - true if CBC for ciphers is required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure ciphers enabled. CBC is a weak alternative. Anything weaker should be avoided and is thus not available.
* `weak_hmac = false` - true if weaker HMAC mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure HMACs enabled.
* `weak_kex = false` - true if weaker Key-Exchange (KEX) mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure KEXs enabled.
* `allow_root_with_key = false` - `false` to disable root login altogether. Set to `true` to allow root to login via key-based mechanism.
* `ports = [ 22 ]` - ports to which ssh-server should listen to and ssh-client should connect to
* `listen_to = [ "0.0.0.0" ]` - one or more ip addresses, to which ssh-server should listen to. Default is empty, but should be configured for security reasons!
* `remote_hosts` - one or more hosts, to which ssh-client can connect to. Default is empty, but should be configured for security reasons!
* `allow_tcp_forwarding = false` - set to true to allow TCP forwarding
* `allow_agent_forwarding = false` - set to true to allow Agent forwarding
* `use_pam = false` to disable pam authentication
* `client_options = {}` - set values in the hash to override the module's settings
* `server_options = {}` - set values in the hash to override the module's settings

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

### Overwriting default options
Default options will be merged with options passed in by the `client_options` and `server_options` parameters.
If an option is set both as default and via options parameter, the latter will win.

The following example will enable X11Forwarding, which is disabled by default:

```puppet
class { 'ssh_hardening':
  server_options => {
    'X11Forwarding' => 'yes',
  },
}
```

## FAQ / Pitfalls

**I can't log into my account. I have registered the client key, but it still doesn't let me it.**

If you have exhausted all typical issues (firewall, network, key missing, wrong key, account disabled etc.), it may be that your account is locked. The quickest way to find out is to look at the password hash for your user:

    sudo grep myuser /etc/shadow

If the hash includes an `!`, your account is locked:

    myuser:!:16280:7:60:7:::

The proper way to solve this is to unlock the account (`passwd -u myuser`). If the user doesn't have a password, you should can unlock it via:

    usermod -p "*" myuser

Alternatively, if you intend to use PAM, you enabled it via `use_pam = true`. PAM will allow locked users to get in with keys.


**Why doesn't my application connect via SSH anymore?**

Always look into log files first and if possible look at the negotation between client and server that is completed when connecting.

We have seen some issues in applications (based on python and ruby) that are due to their use of an outdated crypto set. This collides with this hardening module, which reduced the list of ciphers, message authentication codes (MACs) and key exchange (KEX) algorithms to a more secure selection.

If you find this isn't enough, feel free to activate `cbc_required` for ciphers, `weak_hmac` for MACs, and `weak_kex` for KEX.

## Contributors + Kudos

* Dominik Richter [arlimus](https://github.com/arlimus)
* Edmund Haselwanter [ehaselwanter](https://github.com/ehaselwanter)
* Christoph Hartmann [chris-rock](https://github.com/chris-rock)
* Patrick Meier [atomic111](https://github.com/atomic111)
* Matthew Haughton [3flex](https://github.com/3flex)
* Bernhard Schmidt [bernhardschmidt](https://github.com/bernhardschmidt)
* Kurt Huwig [kurthuwig](https://github.com/kurthuwig)
* Artem Sidorenko [artem-sidorenko](https://github.com/artem-sidorenko)
* Guillaume Destuynder [gdestuynder](https://github.com/gdestuynder)
* Bernhard Weisshuhn [bkw](https://github.com/bkw)
* [stribika](https://github.com/stribika)

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

[1]: https://forge.puppetlabs.com/hardening/ssh_hardening
[2]: http://travis-ci.org/hardening-io/puppet-ssh-hardening
[3]: https://gitter.im/hardening-io/general
