# Sneak this hack in here. Hopefully nobody will notice.
unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require File.join(Rails.root + "lib/async/base.rb")
Dir[File.join(Rails.root, "lib/async/**/*.rb")].each { |file| require file }

require './lib/tagdiffer'
require './lib/text_parser'
