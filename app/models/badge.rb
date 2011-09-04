class Badge < ActiveRecord::Base
  TYPES = %w[gold silver bronze]
  GOLD = %w[great_answer great_question]
  SILVER = %w[good_answer good_question]
  BRONZE = %w[nice_answer nice_question student teacher]

  belongs_to :source, :polymorphic => true
  belongs_to :user

  default_scope order('created_at DESC')

  def self.recent
    limit(10)
  end

  def self.all_badges
    badges = []
    (GOLD + SILVER + BRONZE).sort { |a, b| a <=> b }.each do |b|
      badges << Badge.new(:token => b)
    end
    badges
  end

  def self.new_from_param(param)
    Badge.new(:token => Badge.inverse_param(param))
  end

  def self.param_token(param)
    where('token = ?', Badge.inverse_param(param))
  end

  def self.user(user)
    where("user_id = #{user.id}")
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
