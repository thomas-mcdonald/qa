require 'badge_manager'

module Jobs
  class Badge
    include Sidekiq::Worker

    # TODO: work out how to test this
    def perform(badge_event, globalid)
      object = GlobalID::Locator.locate(globalid)
      user = object.user
      badges = QA::BadgeManager.badges_for(badge_event.to_sym)
      logger.info "Checking badge #{badge_event} for user ##{user.id}"

      # Iterate through the badges for the event and check if they should be
      # awarded
      badges.each do |badge|
        if badge.new.check(object)
          # The user has satisfied the badge criteria
          awarded = user.badges.where(name: badge.name).exists?
          if !awarded
            logger.info "Awarding badge #{badge.name} to user ##{user.id}"
            user.badges.create(
              subject: object,
              name: badge.name
            )
          end
        end
      end
    end
  end
end