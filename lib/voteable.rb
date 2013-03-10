require 'active_support/concern'

module QA
  module Voteable
    extend ActiveSupport::Concern

    included do
      has_many :votes, as: :post
    end

    def vote_count
      self.votes.where(vote_type_id: [1, 2]).inject(0) { |sum, v| v.vote_type_id == 1 ? sum + 1 : sum - 1 }
    end
  end
end