require 'badge_manager'

module Jobs
  class Badge
    include Sidekiq::Worker

    # TODO: work out how to test this
    def perform(badge_event, globalid)
      object = GlobalID::Locator.locate(globalid)
      user = object.user
      badges = QA::BadgeManager.badges_for(badge_event)

      # Iterate through the badges for the event and check if they should be
      # awarded
      badges.each do |badge|
        if badge.new.check(answer)
          # The user has satisfied the badge criteria
          awarded = user.badges.where(name: badge.name).exists?
          if !awarded
            User.badges.create(
              subject: object,
              name: badge.name
            )
          end
        end
      end
    end
  end
end