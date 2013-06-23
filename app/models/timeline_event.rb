class TimelineEvent < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  has_many :timeline_actors
end