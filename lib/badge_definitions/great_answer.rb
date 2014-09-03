require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class GreatAnswer < Base
      @check_on = :answer_vote
      @name = :great_answer

      def check(answer)
        answer.vote_count >= 25
      end
    end
  end
end
