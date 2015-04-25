module QA
  module BadgeDefinition
    class Base
      class << self
        attr_reader :check_on, :name, :type
      end
    end
  end
end
