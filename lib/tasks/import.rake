require 'qa/importer'

namespace :import do
  task :all => :environment do
    QA::Importer::StackExchange.new.execute
  end
end

