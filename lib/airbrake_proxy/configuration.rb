require 'securerandom'

module AirbrakeProxy
  class Configuration
    attr_accessor :redis, :logger
  end
end
