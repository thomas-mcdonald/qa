class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :questions, :through => :taggings

  validates_presence_of :name
end