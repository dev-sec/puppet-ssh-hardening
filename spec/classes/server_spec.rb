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

describe 'ssh_hardening::server' do

  let(:facts) do
    { :osfamily => 'redhat' }
  end

  it do
    should contain_file('/etc/ssh').with(
      'ensure' => 'directory',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0755'
    )
  end

  it { should contain_class('ssh::server').with_storeconfigs_enabled(false) }

  # default configuration
  expect_option('ssh::server', 'Port', [22])
  # user configuration
  context 'with ports => [8022]' do
    let(:params) { { :ports => [8022] } }
    expect_option('ssh::server', 'Port', [8022])
  end

  # user configuration
  context 'with listen_to => 1.2.3.4' do
    let(:params) { { :listen_to => '1.2.3.4' } }
    expect_option('ssh::server', 'ListenAddress', '1.2.3.4')
  end

  # default configuration
  expect_option('ssh::server', 'HostKey', [])
  # user configuration
  context 'with host_key_files => [/a/file]' do
    let(:params) { { :host_key_files => ['/a/file'] } }
    expect_option('ssh::server', 'HostKey', ['/a/file'])
  end

  # default configuration
  expect_option('ssh::server', 'ClientAliveInterval', 600)
  # user configuration
  context 'with client_alive_interval => 300' do
    let(:params) { { :client_alive_interval => 300 } }
    expect_option('ssh::server', 'ClientAliveInterval', 300)
  end

  # default configuration
  expect_option('ssh::server', 'ClientAliveCountMax', 3)
  # user configuration
  context 'with client_alive_count => 2' do
    let(:params) { { :client_alive_count => 2 } }
    expect_option('ssh::server', 'ClientAliveCountMax', 2)
  end

  # default configuration
  expect_option('ssh::server', 'PermitRootLogin', 'no')
  # user configuration
  context 'with allow_root_with_key => true' do
    let(:params) { { :allow_root_with_key => true } }
    expect_option('ssh::server', 'PermitRootLogin', 'without-password')
  end
  context 'with allow_root_with_key => false' do
    let(:params) { { :allow_root_with_key => false } }
    expect_option('ssh::server', 'PermitRootLogin', 'no')
  end

  # default configuration
  expect_option('ssh::server', 'AddressFamily', 'inet')
  # user configuration
  context 'with ipv6_enabled => true' do
    let(:params) { { :ipv6_enabled => true } }
    expect_option('ssh::server', 'AddressFamily', 'any')
  end
  context 'with ipv6_enabled => false' do
    let(:params) { { :ipv6_enabled => false } }
    expect_option('ssh::server', 'AddressFamily', 'inet')
  end

  # default configuration
  expect_option('ssh::server', 'UsePAM', 'no')
  # user configuration
  context 'with use_pam => true' do
    let(:params) { { :use_pam => true } }
    expect_option('ssh::server', 'UsePAM', 'yes')
  end
  context 'with use_pam => false' do
    let(:params) { { :use_pam => false } }
    expect_option('ssh::server', 'UsePAM', 'no')
  end

  # default configuration
  expect_option('ssh::server', 'AllowTcpForwarding', 'no')
  # user configuration
  context 'with allow_tcp_forwarding => true' do
    let(:params) { { :allow_tcp_forwarding => true } }
    expect_option('ssh::server', 'AllowTcpForwarding', 'yes')
  end
  context 'with allow_tcp_forwarding => true' do
    let(:params) { { :allow_tcp_forwarding => false } }
    expect_option('ssh::server', 'AllowTcpForwarding', 'no')
  end

  # default configuration
  expect_option('ssh::server', 'AllowAgentForwarding', 'no')
  # user configuration
  context 'with allow_agent_forwarding => true' do
    let(:params) { { :allow_agent_forwarding => true } }
    expect_option('ssh::server', 'AllowAgentForwarding', 'yes')
  end
  context 'with allow_agent_forwarding => false' do
    let(:params) { { :allow_agent_forwarding => false } }
    expect_option('ssh::server', 'AllowAgentForwarding', 'no')
  end

end
