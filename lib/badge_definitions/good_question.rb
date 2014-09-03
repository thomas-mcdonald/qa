require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class GoodQuestion < Base
      @check_on = :question_vote
      @name = :good_question

      def check(question)
        question.vote_count >= 10
      end
    end
  end
end
