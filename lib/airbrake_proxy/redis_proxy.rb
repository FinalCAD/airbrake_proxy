module RedisProxy
  extend self

  def method_missing method, *args
    tries = 0
    begin
      redis.send method, *args
    rescue Redis::TimeoutError, Redis::CannotConnectError
      if (tries += 1) < 10
        Rails.logger.warn '[RedisProxy] Retry a Redis call'
        retry
      else
        Rails.logger.warn '[RedisProxy] Fail a Redis call after 10 tries'
        raise
      end
    end
  end

  private

  def redis
    @redis ||= AirbrakeProxy.configuration.redis
  end
end
