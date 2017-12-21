# frozen_string_literal: true
module PartialTestcase
  class MissingRenderError < StandardError
    def initialize(msg = 'You must call render first!')
      super
    end
  end
end
