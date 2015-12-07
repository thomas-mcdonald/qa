require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class GreatAnswer < Base
      @check_on = :answer_vote
      @name = :great_answer
      @type = :gold
      @unique = false

      def check(answer)
        answer.vote_count >= 100
      end
    end
  end
end
