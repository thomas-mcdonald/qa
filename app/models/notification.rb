class Notification < ActiveRecord::Base
  belongs_to :redirect, :polymorphic => true
  belongs_to :user
  serialize :parameters
  scope :active, where('dismissed = ?', false)

  def self.dismiss!(id, current_user)
    n = current_user.notifications.find(id)
    return false unless n
    n.dismissed = true
    n.save
  end
end
