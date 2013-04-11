require 'active_support/concern'

module QA
  module Voteable
    extend ActiveSupport::Concern

    included do
      has_many :votes, as: :post
    end

    def update_vote_count!
      self.vote_count = self.votes.where(vote_type_id: [1,2]).inject(0) { |sum, v| v.vote_type_id == 1 ? sum + 1 : sum - 1 }
      save
    end

    def has_vote_by_user(user, vote_type_id)
      !!self.vote_by_user(user, vote_type_id)
    end

    def vote_by_user(user, vote_type_id)
      self.votes.where(user_id: user.id, vote_type_id: vote_type_id).first
    end
  end
end