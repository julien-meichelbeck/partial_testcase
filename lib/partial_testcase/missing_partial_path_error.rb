# frozen_string_literal: true
module PartialTestcase
  class MissingPartialPathError < StandardError
    def initialize(msg = 'You must specify the path of the partial you are testing.')
      super
    end
  end
end
