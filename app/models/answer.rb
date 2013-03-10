require_dependency 'voteable'

class Answer < ActiveRecord::Base
  include QA::Voteable

  belongs_to :question
  belongs_to :user
end