module Async
  module Badges
    class CreateAnswer < Base
      @queue = :medium

      def self.perform(id)
        answer = Answer.find(id)
        question = answer.question
        Notification.create({
          :token => 'new_answer',
          :parameters => {
            :id => question.id,
            :title => question.title
          },
          :redirect => question,
          :user => question.user
        })
      end
    end
  end
end