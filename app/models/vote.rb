class Vote < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  has_many :reputation_events, as: :action, dependent: :destroy
  belongs_to :user

  enum vote_type: { upvote: 1, downvote: 2 }

  validates_presence_of :post_type, :post_id, :user_id, :vote_type
  validate :validate_one_updown_vote
  validate :validate_not_own_post

  after_destroy :update_post_vote_count

  # alias types to vote_types
  def self.types
    vote_types
  end

  def event_type
    # TODO: return nil or something appropriate if not an updown vote
    str = post_type.downcase + '_'
    str << 'upvote' if upvote?
    str << 'downvote' if downvote?
    str
  end

  def locked?
    (post.last_active_at < 2.days.ago) && (post.last_active_at < created_at)
  end

  def update_post_vote_count
    self.post.update_vote_count!
  end

  def validate_one_updown_vote
    if self.post.votes.where(user_id: self.user.id, vote_type: [1,2]).length > 0
      self.errors[:base] << 'Can only vote once on a post'
    end
  end

  def validate_not_own_post
    if self.post.user_id == self.user_id
      self.errors[:base] << 'You cannot vote on your own posts'
    end
  end
end
