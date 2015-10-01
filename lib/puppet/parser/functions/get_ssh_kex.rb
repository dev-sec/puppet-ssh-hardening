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
  ssh_vers = args[0]
  use_weak = args[1] ? 'weak' : 'default'

  # min vers. 5.9
  kex = {}
  kex.default = 'diffie-hellman-group-exchange-sha256'
  kex['weak'] = kex['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

  if Puppet::Util::Package.versioncmp(ssh_vers, '6.6') >= 0
    kex.default = 'curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256'
    kex['weak'] = kex['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'
  end

  kex[use_weak]
end
