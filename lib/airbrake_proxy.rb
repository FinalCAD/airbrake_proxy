require_relative 'airbrake_proxy/redis_proxy'
require_relative 'airbrake_proxy/configure'
require_relative 'airbrake_proxy/version'

require 'active_support/inflector'
require 'time_constants'

require 'airbrake'

module AirbrakeProxy
  extend self
  extend Configure

  class TooManyNotification < StandardError; end

  def notify(exception, params)
    unless exception
      logger.error("AirbrakeProxy#notify(#{exception}, #{params}) => called without exception")
      return false
    end

    safe_notify(exception) { Airbrake.notify(exception, params) }
    true
  rescue TooManyNotification => e
    logger.info("AirbrakeProxy => #{e.message}")
  end

  def keys
    _keys.map { |key| [key, RedisProxy.get(key)] }
  end

  def clean!
    _keys.each { |key| RedisProxy.del(key) }
  end

  def remove(key)
    if key.match(KEY_PREFIX)
      RedisProxy.del(key) == 1 ? true : false
    else
      false
    end
  end

  protected

  KEY_PREFIX = 'AIRBRAKE::'.freeze

  private

  def _keys
    RedisProxy.keys.select { |key| key.match(KEY_PREFIX) }
  end

  THRESHOLD = 5

  def safe_notify(exception)
    redis_key = key(exception)

    unless authorized_to_notify?(redis_key)
      raise TooManyNotification.new("#{redis_key} was notified too many times")
    end
    yield
  end

  def key(exception)
    "#{KEY_PREFIX}#{(exception&.message || exception.inspect).parameterize}"
  end

  def authorized_to_notify?(key)
    return false if RedisProxy.get(key).to_i >= THRESHOLD # We won't hint Redis#incr(key) to not reset timelife of key
    mark_as_notify(key) # return value is a true predicate
  end

  def mark_as_notify(key)
    unless RedisProxy.exists(key)
      RedisProxy.set(key, 0)
      RedisProxy.expire(key, T_5_HOURS)
    end
    RedisProxy.incr(key)
  end

  private

  def logger
    @logger ||= AirbrakeProxy.configuration.logger
  end

end
