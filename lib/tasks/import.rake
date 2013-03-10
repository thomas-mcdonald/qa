namespace :import do
  desc "Import from a Stack Exchange 2.0 Data Dump"
  task se: :environment do
    require 'import'
    QA::Import::StackExchange.new('/Users/tom/Documents/Vuze Downloads/Stack Exchange Data Dump - Aug 2012/Content/bicycles.stackexchange')
  end
end