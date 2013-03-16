$redis = Redis.new
$view = Redis::Namespace.new(:view, redis: $redis)