# encoding: utf-8
#
# Copyright 2014, Deutsche Telekom AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Puppet::Parser::Functions.newfunction(:get_ssh_kex, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  osmajor = osrelease.sub(/\..*/, '')
  weak_kex = args[2] ? 'weak' : 'default'

  kex_59 = {}
  kex_59.default = 'diffie-hellman-group-exchange-sha256'
  kex_59['weak'] = kex_59['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

  kex_66 = {}
  kex_66.default = 'curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256'
  kex_66['weak'] = kex_66['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

  # creat the default version map (if os + version are default)
  default_vmap = {}
  default_vmap.default = kex_59

  # create the main map
  m = {}
  m.default = default_vmap

  m['ubuntu'] = {}
  m['ubuntu']['12'] = kex_59
  m['ubuntu']['14'] = kex_66
  m['ubuntu'].default = kex_59

  m['debian'] = {}
  m['debian']['6'] = ''
  m['debian']['7'] = kex_59
  m['debian']['8'] = kex_66
  m['debian'].default = kex_59

  m['redhat'] = {}
  m['redhat']['6'] = ''
  m['redhat'].default = kex_59

  m['centos'] = m['redhat']
  m['oraclelinux'] = m['redhat']

  m[os][osmajor][weak_kex]
end
