module Badges
  class CreateQuestionVote < Base
    @queue = :medium

    def self.perform(id)
      question = Question.find(id)
      if question.vote_count == 1
        create_badge("student", question.user, question)
      end

      if question.vote_count >= 10
        check = question.badges.where("user_id = #{question.user.id}").where("token = 'nice_question'").first
        create_badge("nice_question", question.user, question) unless check
      end

      if question.vote_count >= 25
        check = question.badges.where("user_id = #{question.user.id}").where("token = 'good_question'").first
        create_badge("good_question", question.user, question) unless check
      end

      if question.vote_count >= 100
        check = question.badges.where("user_id = #{question.user.id}").where("token = 'great_question'").first
        create_badge("great_question", question.user, question) unless check
      end
    end
  end
end
