class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title,
    :answers_count, :view_count, :vote_count

  has_many :tags
end
