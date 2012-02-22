class Answer < ActiveRecord::Base
  has_paper_trail
  has_many :badges, :as => "source"
  has_many :comments, :as => "post"
  has_many :flags, :as => "flaggable"
  belongs_to :question, :counter_cache => true
  belongs_to :user
  has_many :votes, :as => "voteable"

  validates_numericality_of :question_id, :user_id
  validates_presence_of :body
  validates_length_of :body, :minimum => 30

  scope :with_score, select('answers.*, (SUM(votes.value)) as score')
    .joins(:votes)
    .group('answers.id')
    .order('score DESC')

  attr_accessible :body, :question_id, :user_id

  def self.deleted
    self.unscoped.where('deleted_at IS NOT NULL')
  end

  def vote_count
    votes = self.votes
    i = 0
    votes.each do |v|
      i += v.value
    end
    i
  end

  def appear_deleted?
    return true if self.deleted_at or self.question.deleted?
  end

  def accepted?
    question.accepted_answer_id == id
  end
end
