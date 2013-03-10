require_dependency 'slugger'
require_dependency 'voteable'

class Question < ActiveRecord::Base
  include QA::Slugger
  include QA::Voteable

  has_many :answers
  belongs_to :user

  default_scope { order('created_at DESC') }

  validates_length_of :title, within: 10..150
  validates_presence_of :body, :title

  is_slugged :title
end