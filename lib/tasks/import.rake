namespace :import do
  desc "Import from a Stack Exchange 2.0 Data Dump"
  task se: :environment do
    require 'import'
    QA::Import::StackExchange.new(File.join(Rails.root, 'lib/import/data'))
    puts 'Deduplicating sidekiq queues'
    Rake::Task['sidekiq:deduplicate'].invoke
    print " - done!\n"
    puts ''
    puts 'Run `bundle exec sidekiq` to update cache counters and initialize reputation counts'
  end
end
