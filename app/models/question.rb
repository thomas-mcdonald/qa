require_dependency 'last_activity'
require_dependency 'slugger'
require_dependency 'timeline'
require_dependency 'voteable'

class Question < ActiveRecord::Base
  include QA::LastActivity
  include QA::Slugger
  include QA::Timeline
  include QA::Voteable

  has_many :answers
  has_many :comments, as: :post
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :timeline_events, as: :post
  belongs_to :user

  default_scope { order('questions.last_active_at DESC') }

  validates_length_of :title, within: 10..150
  # TODO: make this a config setting
  validates_length_of :body, within: 10..30000
  validates_presence_of :body, :title, :last_active_user_id, :last_active_at
  validate :accepted_is_on_question, :tags_exist

  is_slugged :title

  def accepted_is_on_question
    if accepted_answer_id.present?
      answer_ids = self.answers.pluck(:id)
      if !answer_ids.include? accepted_answer_id.to_i
        self.errors.add(:accepted_answer_id, 'Answer ID must be valid')
      end
    end
  end

  def tags_exist
    self.errors.add(:tag_list, 'Question must be tagged') if self.tags.empty?
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).questions
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def accept_answer(answer)
    self.accepted_answer_id = answer.id
    ReputationEvent.create_on_accept_answer(self, answer)
  end

  def unaccept_answer
    self.accepted_answer_id = nil
  end

  def viewed_by(key)
    $view.sadd("question-#{self.id}", key)
  end

  def view_count
    $view.scard("question-#{self.id}")
  end

  def votes_on_self_and_answers_by_user(user)
    return [] if user == nil
    votes = self.votes.where(user_id: user.id)
    self.answers.includes(:votes).where('votes.user_id = ?', user.id).references(:votes).each do |answer|
      votes += answer.votes
    end
    votes
  end
end
