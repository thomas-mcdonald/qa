module Jobs
  class AnswerStats
    include Sidekiq::Worker

    def perform(answer_id)
      a = Answer.find(answer_id)
      a.update_vote_count!
    end
  end
end