require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class NiceQuestion < Base
      @check_on = :question_vote
      @name = :nice_question
      @type = :bronze
      @unique = false

      def check(question)
        question.vote_count >= 10
      end
    end
  end
end
