module QA
  module Async
    class CreateAnswerVote < Base
      @queue = :medium

      def self.perform(vote_id)
        answer = Vote.find(vote_id).voteable
        process_answer(answer)
      end
    end

    class CreateQuestionVote < Base
      @queue = :medium

      def self.perform(vote_id)
        question = Vote.find(vote_id).voteable
        process_question(question)
      end
    end
  end
end
