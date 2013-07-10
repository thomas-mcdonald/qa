module Jobs
  class QuestionStats
    include Sidekiq::Worker

    def perform(question_id)
      q = Question.find(question_id)
      Question.update_counters q.id, answers_count: q.answers.length
      q.update_vote_count!
    end
  end
end