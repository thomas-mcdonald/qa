class Badge < ActiveRecord::Base
  TYPES = %w[gold silver bronze]
  GOLD = %w[great_question]
  SILVER = %w[good_question]
  BRONZE = %w[nice_question student]

  belongs_to :source, :polymorphic => true
  belongs_to :user

  default_scope order('created_at DESC')

  def self.recent
    limit(10)
  end

  def name
    I18n.t("badges.#{token}.name")
  end

  def description
    I18n.t("badges.#{token}.description")
  end
end
