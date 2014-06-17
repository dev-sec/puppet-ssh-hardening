require 'spec_helper'

describe 'ssh_hardening::client' do

  let(:facts) {{
    :osfamily => 'redhat'
  }}

  it{ should contain_class('ssh::client').with_storeconfigs_enabled(false) }

  # default configuration
  expect_option('ssh::client','Port',['22'])
  # user configuration
  context 'with ports => [8022]' do
    let(:params) { {:ports => [8022] } }
    expect_option('ssh::client','Port',['8022'])
  end

  # default configuration
  expect_option('ssh::client','AddressFamily','inet')
  # user configuration
  context 'with ipv6_enabled => true' do
    let(:params) { {:ipv6_enabled => true } }
    expect_option('ssh::client','AddressFamily','any')
  end
  context 'with ipv6_enabled => false' do
    let(:params) { {:ipv6_enabled => false } }
    expect_option('ssh::client','AddressFamily','inet')
  end

end