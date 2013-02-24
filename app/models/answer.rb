class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  attr_accessible :body, :question_id, :user_id
end