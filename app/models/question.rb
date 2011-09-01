class Question < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  has_many :answers, :dependent => :destroy
  has_many :taggings
  has_many :tags, :through => :taggings
  has_many :votes, :as => "voteable"

  attr_accessor :tag_list

  attr_accessible :title, :body, :tag_list, :user_id

  default_scope where(:deleted_at => nil)

  before_save :build_tags

  validates_presence_of :user_id
  validates_length_of :title, :within => 10..100
  validates_length_of :body, :minimum => 30

  def self.deleted
    self.unscoped.where('deleted_at IS NOT NULL')
  end

  def self.tagged(tag)
    joins(:tags).where('tags.name = ?', tag)
  end

  def tag_list=(tag_list)
    @tag_list = tag_list
  end

  def tag_list
    @tag_list ||= self.tags.collect { |tag| tag.name }.join(", ")
  end

  def build_tags
    return false if self.tag_list.blank?
    self.tags.clear
    self.tag_list.split(",").each do |tag|
      t = Tag.find_or_create_by_name(tag.strip)
      self.tags << t if !self.tags.include?(t)
    end
    self
  end

  def vote_count
    votes = self.votes
    i = 0
    votes.each do |v|
      i += v.value
    end
    i
  end

  attr_accessible :title, :body, :user_id, :tag_list
end
