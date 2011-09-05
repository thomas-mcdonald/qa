class Notification < ActiveRecord::Base
  belongs_to :redirect, :polymorphic => true
  belongs_to :user
  serialize :parameters
  scope :active, where('dismissed = ?', false)

  def self.dismiss!(id)
    n = Notification.find(id)
    n.dismissed = true
    n.save
  end
end
