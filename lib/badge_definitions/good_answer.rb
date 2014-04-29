require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class GoodAnswer < Base
      @check_on = :answer_vote
      @name = :good_answer

      def check(answer)
        answer.vote_count >= 10
      end
    end
  end
end
