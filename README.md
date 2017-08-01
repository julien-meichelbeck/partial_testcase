# PartialTestcase
PartialTestcase is a gem providing unit tests for your partials.


## Why?
* Integration tests are slow.
* Controller tests are deprecated in favor of integration tests.
* If well written, a partial can be seen as just a simple method returning HTML. That sounds like something that can be easily tested.
* Partials can be messy. With simple units test, it is possible to test all the variants of your view layer.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'partial_testcase'
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
If you test the same partial in every test of the file, use the `partial_path` method:
```ruby
class SampleTest < PartialTestcase::Base
  partial_path 'sample/users'
  
  test 'sample test' do
    render_partial(foo: 'bar')
  end
end
```

Otherwise, you can just specify the partial at each render:
```ruby
render_partial('sample/users', foo: 'bar')
```

### How to include helpers and module?
Use `with_module`:
```ruby
class SampleTest < PartialTestcase::Base
  with_module UsersHelper
end
```

### How to stub methods?
If you need some methods for all tests of the file, use the `with_helpers` method:
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

Or if you want to add specific methods just for one test:

```ruby
test 'sample test' do
  render_partial('sample/user') do
    def format_address
      # ...
    end
  end
end
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
