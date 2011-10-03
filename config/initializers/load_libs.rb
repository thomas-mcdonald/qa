Dir[File.join(Rails.root, "lib/async/**/*.rb")].each { |file| require file }

require './lib/tagdiffer'

