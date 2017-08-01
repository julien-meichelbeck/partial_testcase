require 'test_helper'
User = Struct.new(:name)

class SampleTest < PartialTestcase::Base
  setup do
    @user = User.new('Clark')
  end

  test 'just an example' do
    html = render_partial('sample/user', user: @user)

    # Use the same selectors as in your Controller tests
    assert_select 'span.username', text: 'Clark'

    # Or test directly the rendered html
    expected_html = <<~HTML
      <div>
        <span class="username">Clark</span>
      </div>
    HTML
    assert_equal expected_html, html
  end
end
