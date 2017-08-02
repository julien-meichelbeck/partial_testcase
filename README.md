# PartialTestcase
PartialTestcase is a gem providing unit tests for your partials.

![](https://api.travis-ci.org/julien-meichelbeck/partial_testcase.svg?branch=master)

## Why?
* Integration tests are slow.
* Controller tests are deprecated in favor of integration tests.
* If well written, a partial can be seen as just a simple method returning HTML. That sounds like something that can be easily tested.
* Partials can become messy, even bloated. With simple units test, it is possible to test all the variants of your view layer. How many times did you break something because your forgot to test a branch of your template?

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'partial_testcase'
```

Require the module at the top of your `test_helper.rb`:

```ruby
require 'partial_testcase'
```

You're ready to go!

## Simple example
Let's test the following partial:

```erb
<div>
  <span class="username"><%= user.name %></span>
</div>
```

```ruby
class SampleTest < PartialTestcase::Base
  setup do
    @user = User.new('Clark')
  end

  test 'just an example' do
    html = render_partial('sample/user', user: @user)

    # Use the same selectors as in your Controller tests
    assert_select 'span.username', text: 'Clark'

    # Or directly test the html
    expected_html = <<~HTML
      <div>
        <span class="username">Clark</span>
      </div>
    HTML
    assert_equal expected_html, html
  end
end

```

## Documentation
### How to specify the partial path?
You can just specify the partial at each render:
```ruby
render_partial('sample/users', foo: 'bar')
```

Otherwise, if you test the same partial every time, use the `partial_path` method:
```ruby
class SampleTest < PartialTestcase::Base
  partial_path 'sample/users'

  test 'sample test' do
    render_partial(foo: 'bar')
  end
end
```

### How to declare instance variables?
Use `assign` before rendering the partial.
```ruby
  assign(user: @user) # This will make @user available in the partial
  render_partial
```

### How to include helpers and module?
Use `with_module`:
```ruby
class SampleTest < PartialTestcase::Base
  with_module UsersHelper
end
```

### How to stub methods?
If you want to add specific methods for one test:

```ruby
test 'sample test' do
  render_partial('sample/user') do
    def format_address
      # ...
    end
  end
end
```

If you need the same methods for every test, use the `with_helpers` method:
```ruby
class SampleTest < PartialTestcase::Base
  with_helpers do
    def country
      :us
    en

    def format_address(address, city)
      # ...
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/julien-meichelbeck/partial_testcase.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
