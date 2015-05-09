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

describe 'ssh_hardening::client' do

  let(:facts) do
    { :osfamily => 'redhat' }
  end

  it { should contain_class('ssh::client').with_storeconfigs_enabled(false) }

  # default configuration
  expect_option('ssh::client', 'Port', [22])
  # user configuration
  context 'with ports => [8022]' do
    let(:params) { { :ports => [8022] } }
    expect_option('ssh::client', 'Port', [8022])
  end

  # default configuration
  expect_option('ssh::client', 'AddressFamily', 'inet')
  # user configuration
  context 'with ipv6_enabled => true' do
    let(:params) { { :ipv6_enabled => true } }
    expect_option('ssh::client', 'AddressFamily', 'any')
  end
  context 'with ipv6_enabled => false' do
    let(:params) { { :ipv6_enabled => false } }
    expect_option('ssh::client', 'AddressFamily', 'inet')
  end

end
