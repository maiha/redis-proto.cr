require "pool/connection"
require "protobuf"
require "redis-cluster"

class RedisProto(T)
  def initialize(@pool : ConnectionPool(Redis::Client), @prefix : String, @primary : String = "id")
  end

  def initialize(redis_uri : String, prefix : String, primary : String = "id")
    pool = ConnectionPool(Redis::Client).new do
      Redis::Client.boot(redis_uri)
    end
    initialize(pool, prefix, primary)
  end

  def get(key : String) : T
    get?(key) || raise "No data for `#{key}`"
  end
  
  def get?(key : String) : T?
    key = "%s%s" % [@prefix, key]
    redis.get(key).try{|val| T.from_protobuf(IO::Memory.new(val))}
  end

  def set(obj : T) : String
    key = "%s%s" % [@prefix, obj[@primary]]
    val = String.build{ |io| obj.to_protobuf(io) }
    ret = redis.set(key, val)
    if ret == "OK"
      return key
    else
      raise ret || "(no response)"
    end
  end

  protected def redis
    @pool.connection
  end
end
