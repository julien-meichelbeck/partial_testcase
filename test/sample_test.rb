# frozen_string_literal: true
require 'test_helper'
User = Struct.new(:name)

class SampleTest < PartialTestcase::Base
  with_module Rails.application.routes.url_helpers
  with_helpers do
    def country
      :us
    end

    def logout_path
      '/logout'
    end
  end

  let(:user) { User.new('Clark') }

  describe 'sample partial' do
    it 'displays the username' do
      render_partial('sample/user', user: user)
      assert_select 'span.username', text: 'Clark'
    end

    it 'displays the logout_path if the user is logged in' do
      render_partial('sample/user', user: user)
      assert_select 'a[href="/logout"]', text: 'Sign out'
    end
  end
end
