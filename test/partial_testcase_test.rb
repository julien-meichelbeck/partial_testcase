require 'test_helper'

class PartialTestcase::Test < ActiveSupport::TestCase
  test 'base class is defined' do
    assert_kind_of Module, PartialTestcase
    assert_kind_of Class, PartialTestcase::Base
  end
end
