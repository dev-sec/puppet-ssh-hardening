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

require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.environmentpath = File.expand_path(File.join(Dir.pwd, 'spec'))
end

# Wrap expected value to strings for older releases of Puppet
# These will convert their number to strings; wrap around arrays
def wrap_expected(val)
  return val if Puppet.version.to_f >= 4
  return val.map { |x| wrap_expected(x) } if val.is_a?(Array)
  val.to_s
end

# Helper function to expect a class to have a set of
# options defined. These options are not first-class citizens
# of puppet, but instead a key-value map. So regular rspec matchers
# don't help. To stay DRY, introduce this helper.
#
# @param klass [String] the puppet class which must be contained
# @param key [String] the key in the class' options map to test
# @param val [String] the value in the class' options map to expect
# @return Creates an rspec test to check this expectation.
def expect_option(klass, key, val)
  # test each option
  it do
    should contain_class(klass).with_options(
      lambda do |map|
        # check
        if map[key] == wrap_expected(val)
          true
        else
          fail "#{klass} option #{key.inspect} doesn't match (-- expected, ++ actual):\n"\
            "-- #{val.inspect}\n"\
            "++ #{map[key].inspect}\n"
        end
      end
    )
  end
end
