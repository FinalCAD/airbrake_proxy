# AirbrakeProxy

[![Gem Version](https://badge.fury.io/rb/airbrake_proxy.svg)](http://badge.fury.io/rb/airbrake_proxy)

[![Code Climate](https://codeclimate.com/github/FinalCAD/airbrake_proxy.png)](https://codeclimate.com/github/FinalCAD/airbrake_proxy)

[![Dependency Status](https://gemnasium.com/FinalCAD/airbrake_proxy.png)](https://gemnasium.com/FinalCAD/airbrake_proxy)

[![Build Status](https://travis-ci.org/FinalCAD/airbrake_proxy.png?branch=master)](https://travis-ci.org/FinalCAD/airbrake_proxy) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/github/FinalCAD/airbrake_proxy/badge.svg?branch=master)](https://coveralls.io/github/FinalCAD/airbrake_proxy?branch=master)

Basic Circuit Breaker to attempt not reach Airbrake limit for the same exception

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'airbrake_proxy'
```

Please add a config file on your project.

Rails sample

`config/initializers/airbrake_proxy.rb`

```ruby
AirbrakeProxy.configure do |conf|
  conf.redis  = Resque.redis
  conf.logger = Rails.logger
end
```

in `spec/spec_helper.rb` or `spec/rails_helper.rb`

```ruby
AirbrakeProxy.configure do |conf|
  conf.redis  = MockRedis.new
  conf.logger = Logger.new($stderr)
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install airbrake_proxy

## Usage

Simply use `AirbrakeProxy.notify(exception)` in your code instead of `Airbrake.notify exception`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/airbrake_proxy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
