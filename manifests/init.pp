# === Copyright
#
# Copyright 2014, Deutsche Telekom AG
# Licensed under the Apache License, Version 2.0 (the "License");
# http://www.apache.org/licenses/LICENSE-2.0
#

# == Class: ssh_hardening
#
# The default SSH class which installs the SSH server and client
#
# === Parameters
#
# [*cbc_required*]
#   CBC-meachnisms are considered weaker and will not be used as ciphers by
#   default. Set this option to true if you really need CBC-based ciphers.
#
# [*weak_hmac*]
#   The HMAC-mechanisms are selected to be cryptographically strong. If you
#   require some weaker variants, set this option to true to get safe selection.
#
# [*weak_kex*]
#   The KEX-mechanisms are selected to be cryptographically strong. If you
#   require some weaker variants, set this option to true to get safe selection.
#
# [*ports*]
#   A list of ports that SSH expects to run on. Defaults to 22.
#
# [*listen_to*]
#   A list of addresses which SSH listens on. Best to specify only on address of
#   one interface.
#
# [*host_key_files*]
#   A list of host key files to use.
#
# [*client_alive_interval*]
#   Interval after which the server checks if the client is alive (in seconds).
#
# [*client_alive_count*]
#   The maximum number of failed client alive checks before the client is
#   forcefully disconnected.
#
# [*allow_root_with_key*]
#   Whether to allow login of root. If true, root may log in using the key files
#   specified in authroized_keys. Otherwise any login attempts as user root
#   are forbidden.
#
# [*ipv6_enabled*]
#   Set to true if you need IPv6 support in SSH.
#
# [*allow_tcp_forwarding*]
#   Set to true to allow TCP forwarding
#
# [*allow_agent_forwarding*]
#   Set to true to allow Agent forwarding
#
# [*server_options*]
#   Allow override of default server settings provided by the module.
#
# [*client_options*]
#   Allow override of default client settings provided by the module.
#
class ssh_hardening(
  $cbc_required          = false,
  $weak_hmac             = false,
  $weak_kex              = false,
  $ports                 = [ 22 ],
  $listen_to             = [],
  $host_key_files        = [
    '/etc/ssh/ssh_host_rsa_key',
    '/etc/ssh/ssh_host_dsa_key',
    '/etc/ssh/ssh_host_ecdsa_key'
    ],
  $client_alive_interval = 600,
  $client_alive_count    = 3,
  $allow_root_with_key   = false,
  $ipv6_enabled          = false,
  $use_pam               = false,
  $allow_tcp_forwarding   = false,
  $allow_agent_forwarding = false,
  $server_options         = {},
  $client_options         = {},
) {
  class { 'ssh_hardening::server':
    cbc_required           => $cbc_required,
    weak_hmac              => $weak_hmac,
    weak_kex               => $weak_kex,
    ports                  => $ports,
    listen_to              => $listen_to,
    host_key_files         => $host_key_files,
    client_alive_interval  => $client_alive_interval,
    client_alive_count     => $client_alive_count,
    allow_root_with_key    => $allow_root_with_key,
    ipv6_enabled           => $ipv6_enabled,
    use_pam                => $use_pam,
    allow_tcp_forwarding   => $allow_tcp_forwarding,
    allow_agent_forwarding => $allow_agent_forwarding,
    options                => $server_options,
  }
  class { 'ssh_hardening::client':
    ipv6_enabled => $ipv6_enabled,
    ports        => $ports,
    cbc_required => $cbc_required,
    weak_hmac    => $weak_hmac,
    weak_kex     => $weak_kex,
    options      => $client_options,
  }
}
