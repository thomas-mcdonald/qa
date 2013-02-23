namespace :ci do
  desc "Run tests on Travis. In the cloud. Awesome."
  task :travis do
    # Thanks, Diaspora!
    # https://github.com/diaspora/diaspora/blob/master/lib/tasks/ci.rake
    if ENV['BUILD_TYPE'] == 'cucumber'
      puts "Running Cucumber features"
      system("export DISPLAY=:99.0 && bundle exec rake cucumber")
      raise "Cucumber failed!" unless $?.exitstatus == 0
    else
      puts "Running RSpec"
      system("RSPEC=true bundle exec rake spec")
      raise "RSpec failed!" unless $?.exitstatus == 0
    end
  end
end

task travis: "ci:travis"