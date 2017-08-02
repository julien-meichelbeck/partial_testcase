# frozen_string_literal: true
require 'test_helper'

class PartialTestcaseBaseTest < PartialTestcase::Base
  teardown do
    self.class.partial = nil
    self.class.helpers_context = nil
    self.class.modules = []
  end

  test 'assert_select is included' do
    assert defined?(assert_select)
  end

  test 'render unknown partial throws MissingTemplate error' do
    assert_raise ActionView::MissingTemplate do
      render_partial('foobar')
    end
  end

  test 'render root partial' do
    html = <<~HTML
      <p>Root partial<p>
    HTML
    assert_equal html, render_partial('root_partial')
  end

  test 'render nested partial' do
    html = <<~HTML
      <span class="user-name">Name: Clark Kent<span>
      <span class="user-age">Age: 32<span>
    HTML
    assert_equal html, render_partial('users/presentation')
  end

  test 'assert_select selector' do
    render_partial('users/presentation')
    assert_select '.user-name'
  end

  test 'assert_select without rendering partial' do
    assert_raise Minitest::Assertion do
      assert_select '.user-name'
    end
  end

  test 'partial defined on testsuite' do
    self.class.partial_path('users/presentation')
    render_partial
    assert_select '.user-name'
  end

  test 'partial local_assigns' do
    html = <<~HTML
      <div>
        <img class="user-avatar" src='http://foobar.com' />
      </div>
    HTML
    assert_equal html, render_partial('users/avatar', avatar: 'http://foobar.com')
  end

  test 'include helpers' do
    self.class.with_helpers do
      def format_address(city)
        "10 Pennyworth Street, #{city}"
      end
    end

    expected = <<~HTML
      10 Pennyworth Street, Gotham
    HTML
    assert_equal expected, render_partial('users/address', city: 'Gotham')
  end

  test 'include helpers with dynamic block' do
    html =
      render_partial('users/address', city: 'Gotham') do
        def format_address(city)
          "10 Pennyworth Street, #{city}"
        end
      end

    expected = <<~HTML
      10 Pennyworth Street, Gotham
    HTML
    assert_equal expected, html
  end

  module ExistingHelper
    def format_address(city)
      "10 Pennyworth Street, #{city}"
    end
  end

  test 'include existing helper' do
    self.class.with_module ExistingHelper
    html = render_partial('users/address', city: 'Gotham')
    expected = <<~HTML
      10 Pennyworth Street, Gotham
    HTML
    assert_equal expected, html
  end

  test 'instance variables' do
    assign(user: OpenStruct.new(city: 'Metropolis'))

    html = render_partial('users/user')

    expected = <<~HTML
      <address>Metropolis</address>
    HTML
    assert_equal expected, html
  end

  test 'helpers can be overriden' do
    self.class.with_module ExistingHelper
    self.class.with_helpers do
      def format_address(city)
        "#{city} City"
      end
    end
    html = render_partial('users/address', city: 'Gotham')
    expected = <<~HTML
      Gotham City
    HTML
    assert_equal expected, html
  end
end
