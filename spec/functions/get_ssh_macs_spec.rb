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

require 'spec_helper'

describe 'get_ssh_macs' do

  it 'should exist' do
    Puppet::Parser::Functions.function('get_ssh_macs').should == 'function_get_ssh_macs'
  end

  # it should get the correct macs (default)
  it do
    should run.with_params('', '', false).
      and_return('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160')
  end

  # it should get the correct macs (default weak)
  it do
    should run.with_params('', '', true).
      and_return('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,hmac-sha1')
  end

  # it should get the correct macs (ubuntu 12.04, default)
  it do
    should run.with_params('ubuntu', '12.04', false).
      and_return('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160')
  end

  # it should get the correct macs (ubuntu 12.04, weak)
  it do
    should run.with_params('ubuntu', '12.04', true).
      and_return('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,hmac-sha1')
  end

end
