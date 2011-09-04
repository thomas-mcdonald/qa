Dir[File.join(Rails.root, "lib/badges/*.rb")].each { |file| require file }
