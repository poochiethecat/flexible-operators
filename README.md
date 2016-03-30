# FlexibleOperators

Provides a more expressive way of adding operators to your classes.

## Features

- Add operator for a single type/operation
- Add operator for an array of types/operations
- Add operator for a hash of types/operations

Still to come:
- Make operators commutative (by coercion or adding operator to the other class)
- Remove operators again

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flexible_operators'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flexible_operators

## Usage

```ruby
class A
    include 'flexible-operators'

    def initialize
        @a = "hi"
        @b = 0
    end

    # add single operator with block
    add_operator :+, String do |value|
        @a + value
    end
    add_operator :+, Fixnum { |value| @b + value }


    # add same block for multiple types by specifying an array of types
    add_operator :+, [Fixnum, Float] { |value| @b + value }

    # add multiple types with their own blocks (you can also use an array of types as a key)
    add_operator :+, { String => lambda { |value| @a + value },
                       [Fixnum, Float] => lambda { |value| @b + value } }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/poochiethecat/flexible_operators.
