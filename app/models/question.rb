require_dependency 'slugger'

class Question < ActiveRecord::Base
  include QA::Slugger

  belongs_to :user

  default_scope { order('created_at DESC') }

  validates_length_of :title, within: 10..150
  validates_presence_of :body, :title

  is_slugged :title
end