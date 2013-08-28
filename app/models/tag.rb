class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :questions, through: :taggings

  def frequency
    self.taggings.count
  end
end