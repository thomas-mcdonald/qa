require 'active_support/concern'

module Timeline
  extend ActiveSupport::Concern

  def create_timeline_event!
    TimelineEvent.on_post_create(self, self.user)
  end

  def edit_timeline_event!(user)
    TimelineEvent.on_post_edit(self, user)
  end
end
