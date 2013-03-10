namespace :import do
  desc "Import from a Stack Exchange 2.0 Data Dump"
  task se: :environment do
    require 'import'
    QA::Import::StackExchange.new(File.join(Rails.root, 'lib/import/data'))
  end
end