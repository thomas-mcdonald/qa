require 'coveralls/rake/task'
Coveralls::RakeTask.new

namespace :ci do
  desc "Run tests on Travis-CI"
  task :travis do
    puts "Starting to run spinach..."
    system("bundle exec spinach")
    raise "Spinach failed!" unless $?.exitstatus == 0

    puts "Starting to run rspec..."
    system("export RSPEC=true && bundle exec rake spec")
    raise "RSpec failed!" unless $?.exitstatus == 0

    Rake::Task["coveralls:push"].invoke
  end
end

task travis: "ci:travis"