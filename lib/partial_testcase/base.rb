# frozen_string_literal: true
module PartialTestcase
  class Base < ::ActionView::TestCase
    include Rails::Dom::Testing::Assertions

    attr_reader :html_body
    class_attribute :partial

    def setup
      super
      setup_view
    end

    def self.partial_path(partial)
      self.partial = partial
    end

    private

    def setup_view
      @view =
        Class.new(::ActionView::Base) {
          def view_cache_dependencies; end

          def combined_fragment_cache_key(key)
            [:views, key]
          end
        }.new(ApplicationController.view_paths, {})
    end

    def document_root_element
      Nokogiri::XML(@html_body.to_s)
    end

    def render_partial(*args)
      options = args.extract_options!
      partial_path = args[0] || self.class.partial_path

      if partial_path.nil?
        raise "You must specify the path of the partial you are testing. Call the class method 'partial_path'"
      end

      @html_body = @view.render(partial: partial_path, locals: options)
    end
  end
end
