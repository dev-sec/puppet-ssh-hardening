Puppet::Parser::Functions::newfunction(:get_ssh_ciphers, :type => :rvalue) do |args|
  os = args[0]
  osrelease = args[1]
  weak_ciphers = args[2] ? 'weak' : 'default'

  ciphers_59 = {}
  ciphers_59.default = 'aes256-ctr,aes192-ctr,aes128-ctr'
  ciphers_59['weak'] = ciphers_59['default'] + ',aes256-cbc,aes192-cbc,aes128-cbc'

  ciphers_66 = {}
  ciphers_66.default = 'chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr'
  ciphers_66['weak'] = ciphers_66['default'] + ',aes256-cbc,aes192-cbc,aes128-cbc'

  # creat the default version map (if os + version are default)
  default_vmap = {}
  default_vmap.default = ciphers_59
  
  # create the main map
  m = {}
  m.default = default_vmap

  m['ubuntu'] = {}
  m['ubuntu']['12.04'] = ciphers_59
  m['ubuntu']['14.04'] = ciphers_66
  m['ubuntu'].default = ciphers_59

  m[os][osrelease][weak_ciphers]
end

