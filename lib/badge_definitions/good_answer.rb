module QA
  module BadgeDefinition
    class GoodAnswer < Base
      @check_on = :answer_vote

      def check(answer)
        answer.vote_count >= 10
      end
    end
  end
end
