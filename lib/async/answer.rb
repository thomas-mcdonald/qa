module Async
  class CreateAnswer < Base
    @queue = :medium

    def self.perform(id)
      answer = Answer.find(id)
      question = answer.question
      question.user.notify('new_answer', {
        :id => question.id,
        :title => question.title
      }, question)
    end
  end
end

