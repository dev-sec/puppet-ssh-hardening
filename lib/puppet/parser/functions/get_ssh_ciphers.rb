Puppet::Parser::Functions::newfunction(:get_ssh_ciphers, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  osmajor = osrelease.sub(/\..*/,'')
  weak_ciphers = args[2] ? 'weak' : 'default'

  ciphers_53 = {}
  ciphers_53.default = 'aes256-ctr,aes192-ctr,aes128-ctr'
  ciphers_53['weak'] = ciphers_53['default'] + ',aes256-cbc,aes192-cbc,aes128-cbc'

  ciphers_66 = {}
  ciphers_66.default = 'chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr'
  ciphers_66['weak'] = ciphers_66['default'] + ',aes256-cbc,aes192-cbc,aes128-cbc'

  # creat the default version map (if os + version are default)
  default_vmap = {}
  default_vmap.default = ciphers_53
  
  # create the main map
  m = {}
  m.default = default_vmap

  m['ubuntu'] = {}
  m['ubuntu']['12'] = ciphers_53
  m['ubuntu']['14'] = ciphers_66
  m['ubuntu'].default = ciphers_53

  m['redhat'] = {}
  m['redhat']['6'] = ciphers_53
  m['redhat'].default = ciphers_53

  m['centos'] = m['redhat']
  m['oraclelinux'] = m['redhat']

  m[os][osmajor][weak_ciphers]
end

