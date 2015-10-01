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

Puppet::Parser::Functions.newfunction(:get_ssh_macs, :type => :rvalue) do |args|
  ssh_vers = args[0]
  use_weak = args[1] ? 'weak' : 'default'

  # min vers. 5.3
  macs = {}
  macs.default = 'hmac-ripemd160,hmac-sha1'

  if Puppet::Util::Package.versioncmp(ssh_vers, '5.9') >= 0
    macs.default = 'hmac-sha2-512,hmac-sha2-256,hmac-ripemd160'
    macs['weak'] = macs['default'] + ',hmac-sha1'
  end

  if Puppet::Util::Package.versioncmp(ssh_vers, '6.6') >= 0
    macs.default = 'hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160'
    macs['weak'] = macs['default'] + ',hmac-sha1'
  end

  macs[use_weak]
end
