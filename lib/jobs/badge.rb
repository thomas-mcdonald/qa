require 'badge_manager'

module Jobs
  class Badge
    include Sidekiq::Worker

    # TODO: work out how to test this
    def perform(badge_event, global_id)
      object = GlobalID::Locator.locate(global_id)
      user = object.user
      badges = QA::BadgeManager.badges_for(badge_event.to_sym)
      logger.info "Checking badge #{badge_event} for user ##{user.id}"

      # Iterate through the badges for the event and check if they should be
      # awarded
      update_badge_count = false
      badges.each do |badge|
        if badge.new.check(object)
          # The user has satisfied the badge criteria
          awarded = user.badges.where(name: badge.name).exists?
          if !awarded
            logger.info "Awarding badge #{badge.name} to user ##{user.id}"
            update_badge_count = true
            user.badges.create(
              subject: object,
              name: badge.name
            )
          end
        end
      end
      Jobs::UpdateUserBadgeCount.perform_async(user.id)
    end
  end
end
