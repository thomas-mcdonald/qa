require_relative 'badge_definitions/good_answer'

module QA
  module BadgeManager
    @namespace = QA::BadgeDefinition

    # returns an array of all badges
    def self.badges
      @badges ||= @namespace.constants.select { |sym|
        sym != :Base
      }.map(&@namespace.method(:const_get))
    end

    def self.badges_for(event)
      badges.select { |defn| defn.check_on == event }
    end
  end
end
