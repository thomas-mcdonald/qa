class User < ActiveRecord::Base
  include Slugger

  has_many :answers
  has_many :authorizations
  has_many :badges
  has_many :comments
  has_many :questions
  has_many :reputation_events
  has_many :votes

  accepts_nested_attributes_for :authorizations, allow_destroy: false, reject_if: proc { |obj| obj.blank? }

  is_slugged :name

  def self.find_by_hash(auth_hash)
    if auth = Authorization.where('uid = ?', auth_hash[:uid]).where('provider = ?', auth_hash[:provider]).first
      auth.user
    else
      nil
    end
  end

  def self.new_from_hash(auth_hash)
    user = User.new(
      email: auth_hash[:info][:email],
      name: auth_hash[:info][:name]
    )
    user.authorizations.new(
      email: auth_hash[:info][:email],
      provider: auth_hash[:provider],
      uid: auth_hash[:uid]
    )
    user
  end

  def answer_count
    answers.count
  end

  def badge_count
    badges.count
  end

  def calculate_reputation!
    rep = reputation_events.inject(0) do |sum, event|
      sum + ReputationEvent.reputation_for(event.event_type)
    end
    self.reputation = rep
    self.save
  end

  def display_name
    if admin?
      name + " ♦"
    else
      name
    end
  end

  def email_hash
    Digest::MD5.hexdigest(email.strip.downcase)
  end

  def has_answered?(question)
    question.answers.pluck(:user_id).include?(self.id)
  end

  def has_bronze_badges?
    bronze_count > 0
  end

  def has_silver_badges?
    silver_count > 0
  end

  def has_gold_badges?
    gold_count > 0
  end

  def gravatar(size = 32)
    "https://www.gravatar.com/avatar/#{email_hash}.png?s=#{size}&r=pg&d=identicon"
  end

  def question_count
    questions.count
  end

  def rendered_about_me
    Pipeline.generic_render(about_me)
  end

  def staff?
    admin? || moderator?
  end
end
