# frozen_string_literal: true
module PartialTestcase
  class Base < ::ActionView::TestCase
    include Rails::Dom::Testing::Assertions

    attr_reader :html_body
    class_attribute :partial, :helpers_contexts, :modules
    self.modules = []
    self.helpers_contexts = []

    def before_setup
      setup_view
      super
    end

    def self.partial_path(partial)
      self.partial = partial
    end

    def self.with_helpers(&block)
      helpers_contexts << block
    end

    def self.with_module(mod)
      modules << mod
    end

    def assign(**assigns)
      @_assigns.merge!(assigns)
    end

    protected

    def setup_view
      @html_body = nil
      @_assigns = {}

      @_action_view_class =
        Class.new(::ActionView::Base) do
          def view_cache_dependencies;
          end

          def combined_fragment_cache_key(key)
            [:views, key]
          end
        end
    end

    def document_root_element
      Nokogiri::HTML(@html_body.to_s)
    end

    def render_partial(*args, &block)
      view = @_action_view_class.new(ApplicationController.view_paths, @_assigns)

      self.class.modules.each do |mod|
        @_action_view_class.include(mod)
      end
      self.class.helpers_contexts.each do |context|
        add_to_context(context)
      end
      add_to_context(block)
      add_test_context(view)

      options = args.extract_options!
      partial_path = args[0] || self.class.partial

      if partial_path.nil?
        raise "You must specify the path of the partial you are testing. Call the class method 'partial_path'"
      end

      @html_body = view.render(partial: partial_path, locals: options)
    end

    def add_to_context(block)
      return if block.nil?
      mod = Module.new
      mod.class_eval(&block)
      @_action_view_class.include(mod)
    end

    def add_test_context(view)
      mod = Module.new do
        attr_accessor :test_instance
        def method_missing(method, *args, &block)
          test_instance.send method, *args, &block
        end
      end
      view.class.include(mod)
      view.test_instance = self
    end
  end
end
