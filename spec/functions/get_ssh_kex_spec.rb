# encoding: utf-8

require 'spec_helper'

describe 'get_ssh_kex' do
  include RSpec::Puppet::Support
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('get_ssh_kex').should == 'function_get_ssh_kex'
  end

  it 'should get the correct kex (default)' do
    scope.function_get_ssh_kex(['', '', false]).should eq('diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1')
  end

  it 'should get the correct kex (default weak)' do
    scope.function_get_ssh_kex(['', '', true]).should eq('diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1')
  end

  it 'should get the correct kex (ubuntu 12.04, default)' do
    scope.function_get_ssh_kex(['ubuntu', '12.04', false]).should eq('diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1')
  end

  it 'should get the correct kex (ubuntu 12.04, weak)' do
    scope.function_get_ssh_kex(['ubuntu', '12.04', true]).should eq('diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1')
  end

end
