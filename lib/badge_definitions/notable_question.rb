require 'badge_definitions/base'

module QA
  module BadgeDefinition
    class PopularQuestion < Base
      @check_on = :question_view
      @name = :popular_question
      @type = :silver
      @unique = false

      def check(question)
        question.view_count >= 1000
      end
    end
  end
end
