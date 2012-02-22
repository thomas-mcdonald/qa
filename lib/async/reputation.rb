module QA
  module Async
    class ReputationRecalc
      @queue = :high

      def self.perform(user_id)
        user = User.find(user_id)
        user.refresh_reputation
      end
    end
  end
end