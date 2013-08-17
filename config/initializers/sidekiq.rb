redis_conn = proc {
  Redis.new(:host => Figaro.env.redis_cloud_host, 
                     :port => Figaro.env.redis_cloud_port,
                     :password => Figaro.env.redis_cloud_password)
}

# $redis = Redis.new(:host => Figaro.env.redis_cloud_host, 
#                    :port => Figaro.env.redis_cloud_port,
#                    :password => Figaro.env.redis_cloud_password)

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end
