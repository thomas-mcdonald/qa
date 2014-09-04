require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class GoodQuestion < Base
      @check_on = :question_vote
      @name = :good_question
      @type = :silver

      def check(question)
        question.vote_count >= 25
      end
    end
  end
end
