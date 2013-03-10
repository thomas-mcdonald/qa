class Vote < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  belongs_to :user

  TYPES = {
    UPVOTE: 1,
    DOWNVOTE: 2
  }

  validate :validate_one_updown_vote

  def validate_one_updown_vote
    if self.post.votes.where(user: self.user, vote_type_id: [1,2]).length > 0
      self.errors[:base] << 'Can only vote once on a post'
    end
  end
end