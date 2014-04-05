class TimelineEvent < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  has_many :timeline_actors
  has_many :users, through: :timeline_actors

  enum action: {
    post_create: 1,
    post_edit: 2
  }

  def self.on_post_create(post, user)
    event = TimelineEvent.new(post: post)
    event.action = 'post_create'
    event.timeline_actors << TimelineActor.new(user: user)
    event.save
    event
  end

  def self.on_post_edit(post, user)
    event = TimelineEvent.new(post: post)
    event.action = 'post_edit'
    event.timeline_actors << TimelineActor.new(user: user)
    event.save
    event
  end
end