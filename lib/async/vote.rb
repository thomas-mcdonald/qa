module Async
  class CreateAnswerVote < Base
    @queue = :medium

    def self.perform(vote_id)
      answer = Vote.find(vote_id).voteable
      if answer.vote_count >= 1
        check = Badge.user(answer.user).where("token = 'teacher'").first
        create_badge("teacher", answer.user, answer) unless check
      end
      if answer.vote_count >= 10
        check = answer.badges.user(answer.user).where("token = 'nice_answer'").first
        create_badge("nice_answer", answer.user, answer) unless check
      end
      if answer.vote_count >= 25
        check = answer.badges.user(answer.user).where("token = 'good_answer").first
        create_badge("good_answer", answer.user, answer)
      end
    end
  end

  class CreateQuestionVote < Base
    @queue = :medium

    def self.perform(vote_id)
      question = Vote.find(vote_id).voteable
      if question.vote_count >= 1
        check = Badge.user(question.user).where("token = 'student'").first
        create_badge("student", question.user, question) unless check
      end
      if question.vote_count >= 10
        check = question.badges.user(question.user).where("token = 'nice_question'").first
        create_badge("nice_question", question.user, question) unless check
      end
      if question.vote_count >= 25
        check = question.badges.user(question.user).where("token = 'good_question'").first
        create_badge("good_question", question.user, question) unless check
      end
      if question.vote_count >= 100
        check = question.badges.user(question.user).where("token = 'great_question'").first
        create_badge("great_question", question.user, question) unless check
      end
    end
  end
end

