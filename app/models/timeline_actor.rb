class TimelineActor < ApplicationRecord
  belongs_to :timeline_event
  belongs_to :user
end
