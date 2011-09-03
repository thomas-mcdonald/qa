class Badge < ActiveRecord::Base
  belongs_to :source, :polymorphic => true
  belongs_to :user
end
