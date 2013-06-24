require 'active_support/concern'

module QA
  module Timeline
    extend ActiveSupport::Concern

    def create_timeline_event(user)
      TimelineEvent.on_post_create(self, user)
    end
  end
end