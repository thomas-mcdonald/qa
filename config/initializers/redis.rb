rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

r = Redis.new(:host => resque_config[rails_env].split(":").first, :port => resque_config[rails_env].split(":").last)
$views = Redis::Namespace.new(:views, :redis => r)
