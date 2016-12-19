class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title,
    :answers_count, :view_count, :vote_count,
    :last_active_at,
    :question_link

  has_many :tags
  belongs_to :last_active_user

  def question_link
    question_url(object)
  end
end
