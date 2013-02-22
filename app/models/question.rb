class Question < ActiveRecord::Base
  belongs_to :user

  attr_accessible :body, :title

  default_scope order('created_at DESC')

  validates_length_of :title, within: 10..150
  validates_presence_of :body, :title
end
