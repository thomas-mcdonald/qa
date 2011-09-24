class Notification < ActiveRecord::Base
  belongs_to :redirect, :polymorphic => true
  belongs_to :user
  serialize :parameters
  scope :active, where('dismissed = ?', false)

  validates_presence_of :token
  validates_numericality_of :user_id

  def self.dismiss!(id, user)
    return false unless user.notifications.exists?(id)
    n = user.notifications.find(id)
    n.dismiss!
  end

  def dismiss!
    self.dismissed = true
    self.save
  end
end
