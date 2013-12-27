config = YAML.load(ERB.new(File.new("#{Rails.root}/config/redis.yml").read).result)[Rails.env]

$redis = Redis.new(config)

$view = Redis::Namespace.new(:view, redis: $redis)