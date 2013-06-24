require 'active_support/concern'

module QA
  module Timeline
    extend ActiveSupport::Concern

    included do
      after_create :create_timeline_event
    end

    def create_timeline_event
      TimelineEvent.on_post_create(self, self.user)
    end
  end
end