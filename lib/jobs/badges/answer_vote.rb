require 'badge_manager'

module Jobs
  module Badges
    class AnswerVote
      include Sidekiq::Worker

      def perform(answer_id)
        badges = QA::BadgeManager.badges_for(:answer_vote)
        answer = Answer.find(answer_id)
        user = answer.user

        # iterate through each badge and check if it should be awarded
        badges.each do |badge|
          instance = badge.new
          if instance.check(answer)
            # the answer has met the conditions for the badge
            awarded = user.badges.where(name: badge.name).exists?
            if !awarded
              User.badges.create(
                subject: answer,
                name: badge.name
              )
            end
          end
        end
      end
    end
  end
end
