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

describe 'get_ssh_ciphers' do
  include RSpec::Puppet::Support
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('get_ssh_ciphers').should == 'function_get_ssh_ciphers'
  end

  it 'should get the correct ciphers (default)' do
    scope.function_get_ssh_ciphers(['', '', false]).should eq('aes256-ctr,aes192-ctr,aes128-ctr')
  end

  it 'should get the correct ciphers (default weak)' do
    scope.function_get_ssh_ciphers(['', '', true]).should eq('aes256-ctr,aes192-ctr,aes128-ctr,aes256-cbc,aes192-cbc,aes128-cbc')
  end

  it 'should get the correct ciphers (ubuntu 12.04, default)' do
    scope.function_get_ssh_ciphers(['ubuntu', '12.04', false]).should eq('aes256-ctr,aes192-ctr,aes128-ctr')
  end

  it 'should get the correct ciphers (ubuntu 12.04, weak)' do
    scope.function_get_ssh_ciphers(['ubuntu', '12.04', true]).should eq('aes256-ctr,aes192-ctr,aes128-ctr,aes256-cbc,aes192-cbc,aes128-cbc')
  end

end
