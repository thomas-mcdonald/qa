require_dependency 'slugger'

class Question < ActiveRecord::Base
  include QA::Slugger

  has_many :answers
  belongs_to :user
  has_many :votes, as: :post

  default_scope { order('created_at DESC') }

  validates_length_of :title, within: 10..150
  validates_presence_of :body, :title

  is_slugged :title

  def vote_count
    self.votes.where(vote_type_id: [1, 2]).inject(0) { |sum, v| v.vote_type_id == 1 ? sum + 1 : sum - 1 }
  end
end