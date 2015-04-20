# === Copyright
#
# Copyright 2014, Deutsche Telekom AG
# Licensed under the Apache License, Version 2.0 (the "License");
# http://www.apache.org/licenses/LICENSE-2.0
#

# == Class: ssh_hardening::server
#
# The default SSH class which installs the SSH server
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
# [*options*]
#   Allow override of default settings provided by the module.
#
class ssh_hardening::server (
  $cbc_required           = false,
  $weak_hmac              = false,
  $weak_kex               = false,
  $ports                  = [ 22 ],
  $listen_to              = [],
  $host_key_files         = [],
  $client_alive_interval  = 600,
  $client_alive_count     = 3,
  $allow_root_with_key    = false,
  $ipv6_enabled           = false,
  $use_pam                = false,
  $allow_tcp_forwarding   = false,
  $allow_agent_forwarding = false,
  $options                = {},
) {

  $addressfamily = $ipv6_enabled ? {
    true  => 'any',
    false => 'inet',
  }

  $ciphers = get_ssh_ciphers($::operatingsystem, $::operatingsystemrelease, $cbc_required)
  $macs = get_ssh_macs($::operatingsystem, $::operatingsystemrelease, $weak_hmac)
  $kex = get_ssh_kex($::operatingsystem, $::operatingsystemrelease, $weak_kex)
  $priv_sep = use_privilege_separation($::operatingsystem, $::operatingsystemrelease)

  $permit_root_login = $allow_root_with_key ? {
    true  => 'without-password',
    false => 'no',
  }

  $use_pam_option = $use_pam ? {
    true  => 'yes',
    false => 'no',
  }

  $tcp_forwarding = $allow_tcp_forwarding ? {
    true  => 'yes',
    false => 'no'
  }

  $agent_forwarding = $allow_agent_forwarding ? {
    true  => 'yes',
    false => 'no'
  }

    $default_hardened_options = {
      # Basic configuration
      # ===================

      # Either disable or only allow root login via certificates.
      'PermitRootLogin'                 => $permit_root_login,

      # Define which port sshd should listen to. Default to `22`.
      'Port'                            => $ports,

      # Address family should always be limited to the active
      # network configuration.
      'AddressFamily'                   => $addressfamily,

      # Define which addresses sshd should listen to.
      # Default to `0.0.0.0`, ie make sure you put your desired address
      # in here, since otherwise sshd will listen to everyone.
      'ListenAddress'                   => $listen_to,

      # Define the HostKey
      'HostKey'                         => $host_key_files,

      # Security configuration
      # ======================

      # Set the protocol family to 2 for security reasons.
      # Disables legacy support.
      'Protocol'                        => 2,

      # Make sure sshd checks file modes and ownership before accepting logins.
      # This prevents accidental misconfiguration.
      'StrictModes'                     => 'yes',

      # Logging, obsoletes QuietMode and FascistLogging
      'SyslogFacility'                  => 'AUTH',
      'LogLevel'                        => 'VERBOSE',

      # Cryptography
      # ------------

      # **Ciphers** -- If your clients don't support CTR (eg older versions),
      #   cbc will be added
      # CBC: is true if you want to connect with OpenSSL-base libraries
      # eg Ruby's older Net::SSH::Transport::CipherFactory requires CBC-versions
      # of the given openssh ciphers to work
      #
      'Ciphers'                         => $ciphers,

      # **Hash algorithms** -- Make sure not to use SHA1 for hashing,
      # unless it is really necessary.
      # Weak HMAC is sometimes required if older package versions are used
      # eg Ruby's Net::SSH at around 2.2.* doesn't support sha2 for hmac,
      # so this will have to be set true in this case.
      #
      'MACs'                            => $macs,

      # Alternative setting, if OpenSSH version is below v5.9
      #MACs hmac-ripemd160

      # **Key Exchange Algorithms** -- Make sure not to use SHA1 for kex,
      # unless it is really necessary
      # Weak kex is sometimes required if older package versions are used
      # eg ruby's Net::SSH at around 2.2.* doesn't support sha2 for kex,
      # so this will have to be set true in this case.
      #
      'KexAlgorithms'                   => $kex,

      # Authentication
      # --------------

      # Secure Login directives.
      'UseLogin'                        => 'no',
      'UsePrivilegeSeparation'          => $priv_sep,
      'PermitUserEnvironment'           => 'no',
      'LoginGraceTime'                  => '30s',
      'MaxAuthTries'                    => 2,
      'MaxSessions'                     => 10,
      'MaxStartups'                     => '10:30:100',

      # Enable public key authentication
      'PubkeyAuthentication'            => 'yes',

      # Never use host-based authentication. It can be exploited.
      'IgnoreRhosts'                    => 'yes',
      'IgnoreUserKnownHosts'            => 'yes',
      'HostbasedAuthentication'         => 'no',

      # Disable password-based authentication, it can allow for
      # potentially easier brute-force attacks.
      'UsePAM'                          => $use_pam_option,
      'PasswordAuthentication'          => 'no',
      'PermitEmptyPasswords'            => 'no',
      'ChallengeResponseAuthentication' => 'no',

      # Only enable Kerberos authentication if it is configured.
      'KerberosAuthentication'          => 'no',
      'KerberosOrLocalPasswd'           => 'no',
      'KerberosTicketCleanup'           => 'yes',
      #KerberosGetAFSToken no

      # Only enable GSSAPI authentication if it is configured.
      'GSSAPIAuthentication'            => 'no',
      'GSSAPICleanupCredentials'        => 'yes',

      # In case you don't use PAM (`UsePAM no`), you can alternatively
      # restrict users and groups here. For key-based authentication
      # this is not necessary, since all keys must be explicitely enabled.
      #DenyUsers *
      #AllowUsers user1
      #DenyGroups *
      #AllowGroups group1


      # Network
      # -------

      # Disable TCP keep alive since it is spoofable. Use ClientAlive
      # messages instead, they use the encrypted channel
      'TCPKeepAlive'                    => 'no',

      # Manage `ClientAlive..` signals via interval and maximum count.
      # This will periodically check up to a `..CountMax` number of times
      # within `..Interval` timeframe, and abort the connection once these fail.
      'ClientAliveInterval'             => $client_alive_interval,
      'ClientAliveCountMax'             => $client_alive_count,

      # Disable tunneling
      'PermitTunnel'                    => 'no',

      # Disable forwarding tcp connections.
      # no real advantage without denied shell access
      'AllowTcpForwarding'              => $tcp_forwarding,

      # Disable agent formwarding, since local agent could be accessed through
      # forwarded connection. No real advantage without denied shell access
      'AllowAgentForwarding'            => $agent_forwarding,

      # Do not allow remote port forwardings to bind to non-loopback addresses.
      'GatewayPorts'                    => 'no',

      # Disable X11 forwarding, since local X11 display could be
      # accessed through forwarded connection.
      'X11Forwarding'                   => 'no',
      'X11UseLocalhost'                 => 'yes',

      # Misc. configuration
      # ===================

      'PrintMotd'                       => 'no',
      'PrintLastLog'                    => 'no',
      #Banner /etc/ssh/banner.txt
      #UseDNS yes
      #PidFile /var/run/sshd.pid
      #MaxStartups 10
      #ChrootDirectory none
      #ChrootDirectory /home/%u

      # Configuratoin, in case SFTP is used
      ## override default of no subsystems
      ## Subsystem sftp /opt/app/openssh5/libexec/sftp-server
      #Subsystem sftp internal-sftp -l VERBOSE
      #
      ## These lines must appear at the *end* of sshd_config
      #Match Group sftponly
      #ForceCommand internal-sftp -l VERBOSE
      #ChrootDirectory /sftpchroot/home/%u
      #AllowTcpForwarding no
      #AllowAgentForwarding no
      #PasswordAuthentication no
      #PermitRootLogin no
      #X11Forwarding no
    }

  $merged_options = merge($default_hardened_options, $options)

  class { 'ssh::server':
    storeconfigs_enabled => false,
    options              => $merged_options,
  }

  file {'/etc/ssh':
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root'
  }

}
