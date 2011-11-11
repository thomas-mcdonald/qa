class Question < ActiveRecord::Base
  has_paper_trail :ignore => [:answer_count, :last_activity_at, :last_active_user_id]
  has_many :answers
  has_many :badges, :as => "source"
  has_many :flags, :as => "flaggable"
  has_many :taggings, :autosave => true
  has_many :tags, :through => :taggings
  has_many :votes, :as => "voteable"
  belongs_to :user
  belongs_to :last_active_user, :class_name => "User", :foreign_key => "last_active_user_id"

  attr_accessible :title, :body, :tag_list, :user_id

  default_scope order('last_activity_at DESC')
  scope :question_list_includes, includes(:tags, :votes, :last_active_user)

  before_save :build_tags

  validates_presence_of :user_id, :title, :body
  validates_length_of :title, :within => 10..150
  validates_length_of :body, :minimum => 30
  validates_numericality_of :user_id
  validate :tag_validation

  def self.deleted
    self.unscoped.where('deleted_at IS NOT NULL')
  end

  def self.tagged(tag)
    joins(:tags).where('tags.name = ?', tag)
  end

  def build_tags
    paramtags = self.tag_list.gsub(" ", "").split(",").collect { |t| Tag.find_or_create_by_name(t) }
    self.tags.each do |tag|
      self.tags.delete(tag) unless paramtags.include?(tag)
    end
    paramtags.each do |tag|
      self.tags << tag unless self.tags.include?(tag)
    end
    self
  end

  def tag_validation
    self.errors.add(:tag_list, "must have at least one tag") if tag_list.blank?
  end

  def update_last_activity(user)
    self.last_active_user = user
    self.last_activity_at = DateTime.current
  end

  def update_last_activity!(user)
    self.update_last_activity(user)
    self.save
  end

  def vote_count
    votes = self.votes
    i = 0
    votes.each do |v|
      i += v.value
    end
    i
  end

  def viewed_by(key)
    $views.sadd("question-#{self.id}", key)
  end

  def view_count
    $views.scard("question-#{self.id}")
  end
end
