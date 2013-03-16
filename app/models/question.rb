require_dependency 'slugger'
require_dependency 'voteable'

class Question < ActiveRecord::Base
  include QA::Slugger
  include QA::Voteable

  has_many :answers
  belongs_to :user

  default_scope { order('questions.created_at DESC') }

  validates_length_of :title, within: 10..150
  validates_presence_of :body, :title

  is_slugged :title

  def viewed_by(key)
    $view.sadd("question-#{self.id}", key)
  end

  def view_count
    $view.scard("question-#{self.id}")
  end

  def votes_on_self_and_answers_by_user(user)
    return [] if user == nil
    votes = self.votes.where(user_id: user.id)
    self.answers.includes(:votes).where('votes.user_id = ?', user.id).references(:votes).each do |answer|
      votes += answer.votes
    end
    votes
  end
end