# frozen_string_literal: true
module ViewTestCase
  class Base < ::ActionView::TestCase
    class_attribute :partial
    class_attribute :method_contexts
    class_attribute :view_modules
    self.view_modules = []
    self.method_contexts = []

    def self.helper_methods(&block)
      method_contexts << block
    end

    def self.with_module(mod)
      view_modules << mod
    end

    def document_root_element
      raise MissingRenderError if rendered.blank?
      super
    end

    def view
      @view ||=
        super.tap do |view|
          view.extend(ApplicationHelper) if defined?(ApplicationHelper)
          self.class.view_modules.each { |mod| view.extend(mod) }
        end
    end

    def render(*args, &block)
      self.class.method_contexts << block if block
      self.class.method_contexts.each do |context|
        mod = Module.new
        mod.class_eval(&context)
        view.extend(mod)
      end

      if self.class.partial
        super(self.class.partial, args.extract_options!)
      else
        super
      end
    end
  end
end
