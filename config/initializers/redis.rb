config = YAML.load(ERB.new(File.new("#{Rails.root}/config/redis.yml").read).result)[Rails.env]

$redis = Redis.new(
  host: config[:host],
  port: config[:port],
  password: config[:password],
  db: config[:db]
)

$view = Redis::Namespace.new(:view, redis: $redis)