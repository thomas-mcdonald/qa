namespace :ci do
  desc "Run tests on Travis. In the cloud. Awesome."
  # http://about.travis-ci.org/docs/user/gui-and-headless-browsers/#RSpec%2C-Jasmine%2C-Cucumber
  task :travis do
    ['rake spec', 'rake cucumber'].each do |cmd|
      puts "Starting to run #{cmd}..."
      system("export DISPLAY=:99.0 && bundle exec #{cmd}")
      raise "#{cmd} failed!" unless $?.exitstatus == 0
    end
  end
end

task travis: "ci:travis"