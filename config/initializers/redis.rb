$redis = Redis.new(:host => Figaro.env.redis_cloud_host, 
                   :port => Figaro.env.redis_cloud_port,
                   :password => Figaro.env.redis_cloud_password)