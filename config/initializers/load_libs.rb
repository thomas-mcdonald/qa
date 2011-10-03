Dir[File.join(Rails.root, "lib/async/**/*.rb")].each { |file| require file }

require './lib/preload_associations/preload_associations'
require './lib/tagdiffer'

