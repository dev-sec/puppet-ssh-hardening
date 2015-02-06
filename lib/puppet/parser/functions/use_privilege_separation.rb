# encoding: utf-8
#
# Copyright 2015, Dominik Richter
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

Puppet::Parser::Functions.newfunction(:use_privilege_separation, :type => :rvalue) do |args|
  os = args[0].downcase
  osrelease = args[1]
  osmajor = osrelease.sub(/\..*/, '')

  ps53 = 'yes'
  ps59 = 'sandbox'
  ps = ps59

  # redhat/centos/oracle 6.x has ssh 5.3
  if os == 'redhat' || os == 'centos' || os == 'oraclelinux'
    ps = ps53

  # debian 7.x and newer has ssh 5.9+
  elsif os == 'debian' && osmajor.to_i <= 6
    ps = ps53
  end

  ps
end
