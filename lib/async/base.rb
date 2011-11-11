module QA
  module Async
    class Base
      def self.process_answer(answer)
        if answer.vote_count >= 1
          check = Badge.user(answer.user).where("token = 'teacher'").first
          create_badge("teacher", answer.user, answer) unless check
        end
        if answer.vote_count >= 10
          check = answer.badges.user(answer.user).where("token = 'nice_answer'").first
          create_badge("nice_answer", answer.user, answer) unless check
        end
        if answer.vote_count >= 25
          check = answer.badges.user(answer.user).where("token = 'good_answer'").first
          create_badge("good_answer", answer.user, answer)
        end
        if answer.vote_count >= 100
          check = answer.badges.user(answer.user).where("token = 'great_answer'").first
          create_badge("great_answer", answer.user, answer)
        end
      end

      def self.process_question(question)
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

      def self.create_badge(token, user, source)
        badge = Badge.create(
          :source => source,
          :token => token,
          :user => user
        )
        if badge.source == nil
          badge.user.notify('new_badge_without_source', {
            :badge_id => badge.id,
            :badge_token => badge.token
          })
        else
          n = badge.user.notifications.new(
            :parameters => { :badge_token => badge.token },
            :token => "new_badge_with_#{badge.source_type.downcase}_as_source"
          )
          case badge.source_type
          when "Question"
            n.parameters[:question_title] = badge.source.title
            n.parameters[:question_id] = badge.source.id
          when "Answer"
            n.parameters[:question_id] = badge.source.question.id
            n.parameters[:question_title] = badge.source.question.title
            n.parameters[:answer_id] = badge.source.id
          end
          n.save
        end
        badge
      end
    end
  end
end
