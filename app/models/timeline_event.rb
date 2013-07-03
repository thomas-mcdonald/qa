class TimelineEvent < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  has_many :timeline_actors

  POST_CREATE = 1

  def self.on_post_create(post, user)
    event = TimelineEvent.new(post: post)
    event.action = TimelineEvent::POST_CREATE
    event.timeline_actors << TimelineActor.new(user: user)
    event.save
    event
  end
end