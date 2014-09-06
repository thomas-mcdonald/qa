require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class NiceAnswer < Base
      @check_on = :answer_vote
      @name = :nice_answer
      @type = :bronze

      def check(question)
        question.vote_count >= 10
      end
    end
  end
end
