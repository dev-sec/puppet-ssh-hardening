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
  include RSpec::Puppet::Support
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('get_ssh_macs').should == 'function_get_ssh_macs'
  end

  it 'should get the correct macs (default)' do
    scope.function_get_ssh_macs(['', '', false]).should eq('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160')
  end

  it 'should get the correct macs (default weak)' do
    scope.function_get_ssh_macs(['', '', true]).should eq('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,hmac-sha1')
  end

  it 'should get the correct macs (ubuntu 12.04, default)' do
    scope.function_get_ssh_macs(['ubuntu', '12.04', false]).should eq('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160')
  end

  it 'should get the correct macs (ubuntu 12.04, weak)' do
    scope.function_get_ssh_macs(['ubuntu', '12.04', true]).should eq('hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,hmac-sha1')
  end

end
