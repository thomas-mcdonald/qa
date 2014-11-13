module Jobs
  class UpdateUserBadgeCount
    include Sidekiq::Worker

    def perform(user_id)
      user = User.find(user_id)
      badges = user.badges.all

      bronze_count = 0
      silver_count = 0
      gold_count = 0

      badges.each do |badge|
        case badge.badge_type
        when :bronze
          bronze_count += 1
        when :silver
          silver_count += 1
        when :gold
          gold_count += 1
        else
          raise StandardError
        end
      end

      logger.info("Updating badge count for user ##{user.id}. b=#{bronze_count}, s=#{silver_count}, g=#{gold_count}")

      user.update_attributes({
        bronze_count: bronze_count,
        silver_count: silver_count,
        gold_count: gold_count
      })
      user.save
    end
  end
end