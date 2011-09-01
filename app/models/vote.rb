class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true
  has_one :reputation_event, :as => "reputable", :class_name => "ReputationEvent"

  attr_accessible :user, :value

  validate :one_vote
  validate :not_on_self_post
  validates_numericality_of :value
  validates_presence_of :user_id

  after_save :add_reputation_event

  def one_vote
    vote = Vote.where('voteable_type = ? AND voteable_id = ? AND user_id = ?', self.voteable_type, self.voteable_id, self.user_id).first
    if !(vote.nil? || vote.id == self.id)
      self.errors.add(:voteable, "You have already voted")
    end
  end

  def not_on_self_post
    if self.voteable.user_id == self.user_id
      self.errors.add(:voteable, "You cannot vote on your own posts")
    end
  end

  def add_reputation_event
    return if self.voteable.user == nil
    r = ReputationEvent.new
    r.reputable = self
    r.user = self.voteable.user
    # TODO: switch based on the value of votable type
    if self.voteable_type == "Question"
      if self.value == 1
        r.value = 1
      elsif self.value == -1
        r.value = 2
      end
    elsif self.voteable_type == "Answer"
      if self.value == 1
        r.value = 3
      elsif self.value == -1
        r.value = 4
      end
    else
      return false
    end
    r.save
  end
end
