require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class FamousQuestion < Base
      @check_on = :question_view
      @name = :famous_question
      @type = :gold
      @unique = false

      def check(question)
        question.view_count >= 10_000
      end
    end
  end
end
