class Tagging < ActiveRecord::Base
  belongs_to :question
  belongs_to :tag, :counter_cache => true

  validates_presence_of :question_id, :tag_id
  validates_numericality_of :question_id, :tag_id
end
