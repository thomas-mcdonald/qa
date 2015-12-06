require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class GreatQuestion < Base
      @check_on = :question_vote
      @name = :great_question
      @type = :gold
      @unique = false

      def check(question)
        question.vote_count >= 100
      end
    end
  end
end
