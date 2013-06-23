class TimelineActor < ActiveRecord::Base
  belongs_to :timeline_event
  belongs_to :user
end
