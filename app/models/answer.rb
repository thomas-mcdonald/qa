class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :votes, as: :post

  def vote_count
    self.votes.where(vote_type_id: [1, 2]).inject(0) { |sum, v| v.vote_type_id == 1 ? sum + 1 : sum - 1 }
  end
end