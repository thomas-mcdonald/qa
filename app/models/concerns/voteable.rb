require 'active_support/concern'

module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :post
  end

  def update_vote_count!
    self.vote_count = self.votes.where(vote_type: [1, 2]).inject(0) { |a, e| e.upvote? ? a + 1 : a - 1 }
    save
  end

  def has_vote_by_user(user, vote_type)
    !!self.vote_by_user(user, vote_type)
  end

  def vote_by_user(user, vote_type)
    self.votes.find_by(user_id: user.id, vote_type: vote_type)
  end
end
