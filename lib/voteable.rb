require 'active_support/concern'

module QA
  module Voteable
    extend ActiveSupport::Concern

    included do
      has_many :votes, as: :post
    end

    def vote_count
      self.votes.select { |v| [1,2].include? v.vote_type_id }.inject(0) { |sum, v| v.vote_type_id == 1 ? sum + 1 : sum - 1 }
    end

    def has_vote_by_user(user, vote_type_id)
      !self.votes.where(user_id: user.id, vote_type_id: vote_type_id).empty?
    end
  end
end