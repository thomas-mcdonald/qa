module QA
  module Async
    class Base
      def self.process_answer(answer)
        if answer.vote_count >= 1
          create_badge('teacher', answer.user, answer) unless answer.user.has_badge?('teacher')
        end
        if answer.vote_count >= 10
          create_badge('nice_answer', answer.user, answer) unless answer.user.has_badge?('nice_answer', answer)
        end
        if answer.vote_count >= 25
          create_badge('good_answer', answer.user, answer) unless answer.user.has_badge?('good_answer', answer)
        end
        if answer.vote_count >= 100
          create_badge('great_answer', answer.user, answer) unless answer.user.has_badge?('great_answer', answer)
        end
      end

      def self.process_question(question)
        if question.vote_count >= 1
          create_badge('student', question.user, question) unless question.user.has_badge?('student')
        end
        if question.vote_count >= 10
          create_badge('nice_question', question.user, question) unless question.user.has_badge?('nice_question', question)
        end
        if question.vote_count >= 25
          create_badge('good_question', question.user, question) unless question.user.has_badge?('good_question', question)
        end
        if question.vote_count >= 100
          create_badge('great_question', question.user, question) unless question.user.has_badge?('great_question', question)
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