require 'test_helper'

class ViewTestCase::Test < ActiveSupport::TestCase
  test 'base class is defined' do
    assert_kind_of Module, ViewTestCase
    assert_kind_of Class, ViewTestCase::Base
  end
end
