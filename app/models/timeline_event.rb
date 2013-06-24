class TimelineEvent < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  has_many :timeline_actors

  def self.on_post_create(post, user)
    event = TimelineEvent.new(post: post)
    event.timeline_actors << TimelineActor.new(user: user)
    event.save
    event
  end
end