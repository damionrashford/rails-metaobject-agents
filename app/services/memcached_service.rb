class MemcachedService
  def self.client
    @client ||= Dalli::Client.new(ENV["MEMCACHED_SERVERS"] || "localhost:11211", {
      compress: true,
      namespace: "metaobject_agents_#{Rails.env}",
      expires_in: 1.hour
    })
  end

  def self.with_lock(key, ttl: 30)
    lock_key = "lock:#{key}"
    lock_acquired = client.add(lock_key, Process.pid, ttl)

    if lock_acquired
      begin
        yield
      ensure
        client.delete(lock_key)
      end
    else
      Rails.logger.warn("Could not acquire lock for #{key}")
      raise "Lock acquisition failed for #{key}"
    end
  end

  def self.cache(key, ttl: 300)
    value = client.get(key)

    unless value
      value = yield
      client.set(key, value, ttl)
    end

    value
  end

  def self.invalidate(key)
    client.delete(key)
  end
end
