Dir["#{Rails.root}/lib/jobs/**/*.rb"].each {|file| require_dependency file }
