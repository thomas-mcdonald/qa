require 'active_support/concern'

module QA
  module Timeline
    extend ActiveSupport::Concern

    def create_timeline_event
      TimelineEvent.on_post_create(self, self.user)
    end
  end
end
