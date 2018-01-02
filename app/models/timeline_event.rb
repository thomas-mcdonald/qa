class TimelineEvent < ApplicationRecord
  belongs_to :post, polymorphic: true
  has_one :post_history
  has_many :timeline_actors
  has_many :users, through: :timeline_actors

  enum action: {
    post_create: 1,
    post_edit: 2
  }

  after_save :track_history, if: :should_track_history?

  def track_history
    keys = post.history_keys
    history = keys.each_with_object({}) { |key, acc| acc[key] = post.send(key) }
    PostHistory.create(history.merge(timeline_event: self))
  end

  def should_track_history?
    %w(post_create post_edit).include? action
  end

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
