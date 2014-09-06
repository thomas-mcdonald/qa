['good_answer', 'good_question', 'great_answer', 'great_question',
  'nice_answer', 'nice_question'].each do |f|
  require_relative "badge_definitions/#{f}"
end

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
      badges.select { |klass| klass.check_on == event }
    end

    def self.[](sym)
      badges.select { |klass| klass.name == sym }.first
    end
  end
end
