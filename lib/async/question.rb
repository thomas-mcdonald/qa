module QA
  module Async
    class ResyncQuestion < Base
      @queue = :low

      def self.perform(id)
        question = Question.find(id)
        process_question(question)
      end
    end
  end
end
