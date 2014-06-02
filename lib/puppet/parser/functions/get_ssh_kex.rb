Puppet::Parser::Functions::newfunction(:get_ssh_kex, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  weak_kex = args[2] ? 'weak' : 'default'

  kex_59 = {}
  kex_59.default = 'diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1'
  kex_59['weak'] = kex_59['default'] + ',diffie-hellman-group1-sha1'

  kex_66 = {}
  kex_66.default = 'curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1'
  kex_66['weak'] = kex_66['default'] + ',diffie-hellman-group1-sha1'

  # creat the default version map (if os + version are default)
  default_vmap = {}
  default_vmap.default = kex_59
  
  # create the main map
  m = {}
  m.default = default_vmap

  m['ubuntu'] = {}
  m['ubuntu']['12.04'] = kex_59
  m['ubuntu']['14.04'] = kex_66
  m['ubuntu'].default = kex_59

  m[os][osrelease][weak_kex]
end