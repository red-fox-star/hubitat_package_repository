require "redis"

class ManifestCache
  def initialize(@cache = true)
    @connection = ::Redis.new
  end

  def get_or_set(key, expires_in = 10.minutes, &block) : String
    return yield unless @cache

    if value = get key
      value
    else
      value = yield
      set key, value
      expire key, expires_in.total_seconds.to_i
      value
    end
  end

  forward_missing_to @connection
end
