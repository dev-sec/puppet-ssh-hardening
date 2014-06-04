Puppet::Parser::Functions::newfunction(:get_ssh_macs, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  osmajor = osrelease.sub(/\..*/,'')
  weak_macs = args[2] ? 'weak' : 'default'

  macs_53 = {}
  macs_53.default = 'hmac-ripemd160,hmac-sha1'

  macs_59 = {}
  macs_59.default = 'hmac-sha2-512,hmac-sha2-256,hmac-ripemd160'
  macs_59['weak'] = macs_59['default'] + ',hmac-sha1'

  macs_66 = {}
  macs_66.default = 'hmac-sha2-512-etm@openssh.com,hmac-sha2-512,hmac-sha2-256-etm@openssh.com,hmac-sha2-256,umac-128-etm@openssh.com,hmac-ripemd160-etm@openssh.com,hmac-ripemd160'
  macs_66['weak'] = macs_66['default'] + ',hmac-sha1'

  # creat the default version map (if os + version are default)
  default_vmap = {}
  default_vmap.default = macs_59
  
  # create the main map
  m = {}
  m.default = default_vmap

  m['ubuntu'] = {}
  m['ubuntu']['12'] = macs_59
  m['ubuntu']['14'] = macs_66
  m['ubuntu'].default = macs_59

  m['redhat'] = {}
  m['redhat']['6'] = macs_53
  m['redhat'].default = macs_53

  m['centos'] = m['redhat']
  m['oraclelinux'] = m['redhat']

  m[os][osmajor][weak_macs]
end

