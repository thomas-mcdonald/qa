class Badge < ActiveRecord::Base
  TYPES = %w[gold silver bronze]
  GOLD = %w[great_question]
  SILVER = %w[good_question]
  BRONZE = %w[nice_question student]

  belongs_to :source, :polymorphic => true
  belongs_to :user
end
