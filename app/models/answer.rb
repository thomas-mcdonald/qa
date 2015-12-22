class Answer < ActiveRecord::Base
  include LastActivity
  include Timeline
  include Voteable

  has_many :comments, -> { order('created_at ASC') }, as: :post
  belongs_to :question, counter_cache: true
  has_many :timeline_events, as: :post
  belongs_to :user

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :last_active_user_id, :last_active_at, presence: true
  validates :body, length: { in: 10..30000 }

  def self.question_view_ordering(question)
    if (aaid = question.accepted_answer_id)
      sql = 'CASE id WHEN ? THEN 1 ELSE 2 END, vote_count DESC'
      order(sanitize_sql_array([sql, aaid]))
    else
      order('vote_count DESC')
    end
  end

  def accepted?
    id == question.accepted_answer_id
  end

  def history_keys
    %i(body)
  end
end
