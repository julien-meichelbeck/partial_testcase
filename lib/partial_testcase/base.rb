# frozen_string_literal: true
module PartialTestcase
  class Base < ::ActionView::TestCase
    include Rails::Dom::Testing::Assertions

    attr_reader :html_body
    class_attribute :partial, :helpers_context

    def setup
      super
      setup_view
    end

    def self.partial_path(partial)
      self.partial = partial
    end

    def self.with_helpers(&block)
      self.helpers_context = block
    end

    protected

    def setup_view
      @html_body = nil

      @action_view_class = Class.new(::ActionView::Base) {
        def view_cache_dependencies; end

        def combined_fragment_cache_key(key)
          [:views, key]
        end
      }

      @view = @action_view_class.new(ApplicationController.view_paths, {})
    end

    def document_root_element
      Nokogiri::XML(@html_body.to_s)
    end

    def render_partial(*args, &block)
      add_to_context(self.class.helpers_context)
      add_to_context(block)

      options = args.extract_options!
      partial_path = args[0] || self.class.partial

      if partial_path.nil?
        raise "You must specify the path of the partial you are testing. Call the class method 'partial_path'"
      end

      @html_body = @view.render(partial: partial_path, locals: options)
    end

    def add_to_context(block)
      return if block.nil?
      mod = Module.new
      mod.class_eval(&block)
      @action_view_class.include(mod)
    end
  end
end
