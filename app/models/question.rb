class Question < ActiveRecord::Base
  include LastActivity
  include Slugger
  include Timeline
  include Voteable

  belongs_to :accepted_answer, class_name: Answer
  has_many :answers
  has_many :comments, -> { order('created_at ASC') }, as: :post
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :timeline_events, as: :post
  belongs_to :user

  scope :sort_by, lambda { |kind|
    kind = :activity if kind.nil?

    case kind.to_sym
    when :activity
      order('questions.last_active_at DESC')
    when :votes
      order('questions.vote_count DESC')
    end
  }

  validates :title, length: { in: 10..150 }, presence: true
  validates :body, length: { in: 10..30000 }, presence: true
  validates :last_active_user_id, :last_active_at, presence: true
  validate :accepted_is_on_question, :tags_exist

  VALID_SORT_KEYS = [:activity, :votes]

  is_slugged :title

  def accepted_is_on_question
    return if accepted_answer_id.nil?

    answer_ids = self.answers.pluck(:id)
    if !answer_ids.include? accepted_answer_id.to_i
      self.errors.add(:accepted_answer_id, 'Answer ID must be valid')
    end
  end

  def tags_exist
    self.errors.add(:tag_list, 'Question must be tagged') if self.tags.empty?
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).questions
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count")
      .joins(:taggings).group("taggings.tag_id")
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
    result = $view.pfadd("question-#{self.id}", key)
    Jobs::Badge.perform_async(:question_view, self.to_global_id) if result
  end

  def view_count
    $view.pfcount("question-#{self.id}")
  end

  def votes_on_self_and_answers_by_user(user)
    return [] if user.nil?
    votes = self.votes.where(user_id: user.id)
    self.answers.includes(:votes).where('votes.user_id = ?', user.id).references(:votes).each do |answer|
      votes += answer.votes
    end
    votes
  end
end
