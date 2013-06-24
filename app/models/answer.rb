require_dependency 'timeline'
require_dependency 'voteable'

class Answer < ActiveRecord::Base
  include QA::Timeline
  include QA::Voteable

  belongs_to :question
  has_many :timeline_events, as: :post
  belongs_to :user

  def self.question_view_ordering(question)
    if aaid = question.accepted_answer_id
      sql = 'CASE id WHEN ? THEN 1 ELSE 2 END, vote_count DESC'
      order(sanitize_sql_array([sql, aaid]))
    else
      order('vote_count DESC')
    end
  end
end