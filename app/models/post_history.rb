class PostHistory < ActiveRecord::Base
  belongs_to :timeline_event
end
