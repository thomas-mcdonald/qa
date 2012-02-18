module QA
  module Importer
    class Abstract
      def open_file(path)
        File.open(Rails.root + path)
      end
    end
  end
end