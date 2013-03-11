class Vote < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  belongs_to :user

  UPVOTE = 1
  DOWNVOTE = 2

  validates_presence_of :post_type, :post_id, :user_id, :vote_type_id
  validate :validate_one_updown_vote

  def validate_one_updown_vote
    if self.post.votes.where(user_id: self.user.id, vote_type_id: [1,2]).length > 0
      self.errors[:base] << 'Can only vote once on a post'
    end
  end
end