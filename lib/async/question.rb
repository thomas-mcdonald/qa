module QA
  module Async
    class ResyncQuestion < Base
      @queue = :low

      def self.perform(id)
        question = Question.find(id)
        process_question(question)
        Question.update_counters question.id, :answers_count => question.answers.count
      end
    end
  end
end
