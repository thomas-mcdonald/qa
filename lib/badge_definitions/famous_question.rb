require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class NotableQuestion < Base
      @check_on = :question_view
      @name = :notable_question
      @type = :bronze
      @unique = false

      def check(question)
        question.view_count >= 2500
      end
    end
  end
end
