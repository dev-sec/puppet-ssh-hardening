# === Copyright
#
# Copyright 2014, Deutsche Telekom AG
# Licensed under the Apache License, Version 2.0 (the "License");
# http://www.apache.org/licenses/LICENSE-2.0
#

# == Class: ssh_hardening::client
#
# The default SSH class which installs the SSH client
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
# [*ipv6_enabled*]
#   Set to true if you need IPv6 support in SSH.
#
# [*options*]
#   Allow override of default settings provided by the module.
#
class ssh_hardening::client (
  $cbc_required = false,
  $weak_hmac = false,
  $weak_kex = false,
  $ports = [ 22 ],
  $options      = {},
  $ipv6_enabled = false
) {
  if $ipv6_enabled == true {
    $addressfamily = 'any'
  } else {
    $addressfamily = 'inet'
  }

  $ciphers = get_ssh_ciphers($::operatingsystem, $::operatingsystemrelease, $cbc_required)
  $macs = get_ssh_macs($::operatingsystem, $::operatingsystemrelease, $weak_hmac)
  $kex = get_ssh_kex($::operatingsystem, $::operatingsystemrelease, $weak_kex)

  $ssh_options = {
    # Set the addressfamily according to IPv4 / IPv6 settings
    'AddressFamily'             => $addressfamily,

    # The port at the destination should be defined
    'Port'                      => $ports,

    # Set the protocol family to 2 for security reasons.
    # Disables legacy support.
    'Protocol'                  => 2,

    # Make sure passphrase querying is enabled
    'BatchMode'                 => 'no',

    # Prevent IP spoofing by checking to host IP against the
    # `known_hosts` file.
    'CheckHostIP'               => 'yes',

    # Always ask before adding keys to the `known_hosts` file.
    # Do not set to `yes`.
    'StrictHostKeyChecking'     => 'ask',

    # **Ciphers** -- If your clients don't support CTR (eg older versions),
    #   cbc will be added
    # CBC: is true if you want to connect with OpenSSL-base libraries
    # eg Ruby's older Net::SSH::Transport::CipherFactory requires CBC-versions
    # of the given openssh ciphers to work
    #
    'Ciphers'                   => $ciphers,

    # **Hash algorithms** -- Make sure not to use SHA1
    # for hashing, unless it is really necessary.
    # Weak HMAC is sometimes required if older package
    # versions are used
    # eg Ruby's Net::SSH at around 2.2.* doesn't support
    # sha2 for hmac, so this will have to be set true in this case.
    #
    'MACs'                      => $macs,

    # Alternative setting, if OpenSSH version is below v5.9
    #MACs hmac-ripemd160

    # **Key Exchange Algorithms** -- Make sure not to use SHA1 for kex,
    # unless it is really necessary
    # Weak kex is sometimes required if older package versions are used
    # eg ruby's Net::SSH at around 2.2.* doesn't support sha2 for kex,
    # so this will have to be set true in this case.
    #
    'KexAlgorithms'             => $kex,

    # Disable agent formwarding, since local agent could be accessed
    # through forwarded connection.
    'ForwardAgent'              => 'no',

    # Disable X11 forwarding, since local X11 display could be accessed
    # through forwarded connection.
    'ForwardX11'                => 'no',

    # Never use host-based authentication. It can be exploited.
    'HostbasedAuthentication'   => 'no',
    'RhostsRSAAuthentication'   => 'no',

    # Enable RSA authentication via identity files.
    'RSAAuthentication'         => 'yes',

    # Disable password-based authentication, it can allow for potentially
    # easier brute-force attacks.
    'PasswordAuthentication'    => 'no',

    # Only use GSSAPIAuthentication if implemented on the network.
    'GSSAPIAuthentication'      => 'no',
    'GSSAPIDelegateCredentials' => 'no',

    # Disable tunneling
    'Tunnel'                    => 'no',

    # Disable local command execution.
    'PermitLocalCommand'        => 'no',

    # Misc. configuration
    # ===================

    # Enable compression. More pressure on the CPU, less on the network.
    'Compression'               => 'yes',

    #EscapeChar ~
    #VisualHostKey yes
  }

  $merged_options = merge($ssh_options, $options)

  class { 'ssh::client':
    storeconfigs_enabled => false,
    options              => delete_undef_values($merged_options),
  }
}
