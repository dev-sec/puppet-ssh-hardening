require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
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
        if map[key] == val
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
