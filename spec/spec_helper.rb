$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'airbrake_proxy'

require 'mock_redis'

require 'coveralls'
Coveralls.wear!

AirbrakeProxy.configure do |conf|
  conf.redis = MockRedis.new
  conf.logger = Logger.new($stderr)
end

RSpec.configure do |c|
  c.run_all_when_everything_filtered = true
end
