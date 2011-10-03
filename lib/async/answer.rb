module Async
  class CreateAnswer < Base
    @queue = :medium

    def self.perform(id)
      answer = Answer.find(id)
      question = answer.question
      question.user.notify('new_answer', {
        :question_id => question.id,
        :question_title => question.title
      })
    end
  end

  class EditAnswer < Base
    @queue = :medium

    def self.perform(id)
      answer = Answer.find(id)
      question = answer.question
      answer.user.notify('edited_answer', {
        :question_id => question.id,
        :question_title => question.title
      })
    end
  end
end

