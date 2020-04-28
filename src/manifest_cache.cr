require "redis"

class ManifestCache
  def initialize()
    @connection = ::Redis.new
  end

  def get_or_set(key, expires_in = 1.minute, &block) : String
    if value = get key
      value
    else
      value = yield
      set key, value
      value
    end
  end

  forward_missing_to @connection
end
