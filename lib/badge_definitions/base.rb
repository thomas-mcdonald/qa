module QA
  module BadgeDefinition
    class Base
      class << self
        attr_reader :check_on, :name, :type
        alias :badge_type :type

        def translate_key(subkey)
          "#{translation_base_key}.#{subkey.to_s}"
        end

        def translation_base_key
          "badges.#{name}"
        end
      end
    end
  end
end
