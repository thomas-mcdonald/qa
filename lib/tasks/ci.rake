require 'coveralls/rake/task'
Coveralls::RakeTask.new

namespace :ci do
  desc "Run tests on Travis. In the cloud. Awesome."
  # http://about.travis-ci.org/docs/user/gui-and-headless-browsers/#RSpec%2C-Jasmine%2C-Cucumber
  task :travis do
    puts "Starting to run cucumber..."
    system("bundle exec rake cucumber")
    raise "Cucumber failed!" unless $?.exitstatus == 0

    puts "Starting to run rspec..."
    system("export RSPEC=true && bundle exec rake spec")
    raise "RSpec failed!" unless $?.exitstatus == 0

    Rake::Task["coveralls:push"].invoke
  end
end

task travis: "ci:travis"