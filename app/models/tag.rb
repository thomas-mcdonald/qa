class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :questions, through: :taggings

  scope :search, -> (term) { where('name LIKE ?', %(#{term}%)) }

  def self.by_popularity
    select('tags.*, count(*) as count').joins(:taggings).order('count(*) DESC, name ASC').group('tags.id')
  end

  def self.named(name)
    find_by(name: name)
  end

  def frequency
    self.taggings.count
  end

  # This jumps around quite a bit. We pick out all the questions for the
  # specific tag, and then find all the IDs of tags for those questions.
  #
  # We then order them by frequency and pick out the top ten.
  # Could this be a single SQL query? Probably.
  # TODO: Cache this result.
  # TODO: test?
  def related_tags
    q_ids = Tagging.where(tag_id: self.id).pluck(:question_id)
    tag_ids = Tagging.where(question_id: q_ids).group(:tag_id).order('count(*) desc').limit(15).pluck(:tag_id)
    tag_ids.delete(self.id)
    Tag.find(tag_ids)
  end
end
