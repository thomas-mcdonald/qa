class Badge < ActiveRecord::Base
  TYPES = %w[gold silver bronze]
  GOLD = %w[great_answer great_question]
  SILVER = %w[good_answer good_question]
  BRONZE = %w[nice_answer nice_question student teacher]

  belongs_to :source, :polymorphic => true
  belongs_to :user

  validates_presence_of :token
  validates_numericality_of :user_id

  attr_accessor :shallow

  default_scope order('created_at DESC')

  def self.recent
    limit(10).includes(:user)
  end

  def self.all_badges
    badges = []
    (GOLD + SILVER + BRONZE).sort { |a, b| a <=> b }.each do |b|
      badges << Badge.new(:shallow => true, :token => b)
    end
    badges
  end

  def self.new_from_param(param)
    Badge.new(:shallow => true, :token => Badge.inverse_param(param))
  end

  def self.new_from_token(token)
    Badge.new(:shallow => true, :token => token)
  end

  def self.param_token(param)
    where('token = ?', Badge.inverse_param(param))
  end

  def self.user(user)
    where("user_id = ?", user.id)
  end

  def shallow?
    shallow || false
  end

  def to_param
    token.gsub("_", "-")
  end

  def self.inverse_param(s)
    s.gsub("-", "_")
  end

  def type
    if GOLD.include?(token)
      "gold"
    elsif SILVER.include?(token)
      "silver"
    elsif BRONZE.include?(token)
      "bronze"
    end
  end

  def name
    I18n.t("badges.#{token}.name")
  end

  def description
    I18n.t("badges.#{token}.description")
  end
end
