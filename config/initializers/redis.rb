config = YAML.load(ERB.new(File.new("#{Rails.root}/config/redis.yml").read).result)[Rails.env]

$redis = Redis.new(config)

$view = Redis::Namespace.new(:view, redis: $redis)

Sidekiq.configure_server do |c|
  c.redis = { url: %(redis://#{config['host']}:#{config['port']}/#{config['db']}), namespace: 'sidekiq' }
end

Sidekiq.configure_client do |c|
  c.redis = { url: %(redis://#{config['host']}:#{config['port']}/#{config['db']}), namespace: 'sidekiq' }
end
