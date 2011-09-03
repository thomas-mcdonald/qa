class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :questions, :through => :taggings

  validates_presence_of :name

  def self.recent(limit = 10)
    select('tags.*, count(taggings.tag_id) as count').joins(:taggings).where('taggings.created_at > ?', 7.days.ago).group('taggings.tag_id').order('count(taggings.tag_id) DESC').limit(10)
  end
end
