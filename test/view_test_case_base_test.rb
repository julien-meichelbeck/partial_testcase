# frozen_string_literal: true
require 'test_helper'

class ViewTestCaseBaseTest < ViewTestCase::Base
  teardown do
    self.class.partial = nil
    self.class.method_contexts = []
    self.class.view_modules = []
  end

  module ExistingHelper
    def format_address(city)
      "10 Pennyworth Street, #{city}"
    end
  end

  test 'assert_select is included' do
    assert defined?(assert_select)
  end

  test 'render unknown partial throws MissingTemplate error' do
    assert_raise ActionView::MissingTemplate do
      render('foobar')
    end
  end

  test 'render root partial' do
    html = <<~HTML
      <p>Root partial</p>
    HTML
    assert_equal html, render('root_partial')
  end

  test 'render view' do
    render(template: 'sample/index')
    html = <<~HTML
      <p>Hi</p>
    HTML
    assert_equal html, rendered
  end

  test 'use rendered variable' do
    html = <<~HTML
      <p>Root partial</p>
    HTML
    render('root_partial')
    assert_equal html, rendered
  end

  test 'render nested partial' do
    html = <<~HTML
      <span class="user-name">Name: Clark Kent<span>
      <span class="user-age">Age: 32<span>
    HTML
    assert_equal html, render('users/presentation')
  end

  test 'assert_select selector' do
    render('users/presentation')
    assert_select '.user-name'
  end

  test 'include helpers' do
    def city_name(city)
      city.capitalize
    end

    def format_address(city)
      "56 Pennyworth Street, #{city_name(city)}"
    end

    self.class.helper_method :format_address
    self.class.helper_method :city_name

    expected = <<~HTML
      56 Pennyworth Street, Gotham
    HTML
    assert_equal expected, render('users/address', city: 'gotham')
  end

  test 'include existing helper' do
    self.class.with_module ExistingHelper
    html = render('users/address', city: 'Gotham')
    expected = <<~HTML
      10 Pennyworth Street, Gotham
    HTML
    assert_equal expected, html
  end

  test 'partial local_assigns' do
    html = <<~HTML
      <div>
        <img class="user-avatar" src='http://foobar.com' />
      </div>
    HTML
    assert_equal html, render('users/avatar', avatar: 'http://foobar.com')
  end

  test 'instance variables' do
    @user = OpenStruct.new(city: 'Metropolis')

    html = render('users/user')

    expected = <<~HTML
      <address>Metropolis</address>
    HTML
    assert_equal expected, html
  end

  test 'helpers can reference test context' do
    def local_variable
      'defined in test'
    end

    def just_a_helper_method
      local_variable
    end

    self.class.helper_method :just_a_helper_method
    html = render('sample/with_helper_call')
    expected = <<~HTML
      <div>defined in test</div>
    HTML
    assert_equal expected, html
  end

  test 'use all include features' do
    # Bulk helpers
    self.class.helper_methods do
      def format_street
        '52 Pennyworth Street'
      end
    end

    # Single method
    def format_city(city)
      city.upcase
    end
    self.class.helper_method :format_city

    # At render call
    html =
      render('users/address', city: 'Gotham') do
        def format_address(city)
          "#{format_street}, #{format_city(city)}"
        end
      end

    expected = <<~HTML
      52 Pennyworth Street, GOTHAM
    HTML
    assert_equal expected, html
  end

  test 'assert_select without rendering partial' do
    assert_raise ViewTestCase::MissingRenderError do
      assert_select '.user-name'
    end
  end

  test 'partial defined on testsuite' do
    self.class.partial = 'users/presentation'
    render
    assert_select '.user-name'
  end

  test 'partial is mandatory' do
    assert_raise do
      render
    end
  end
end
