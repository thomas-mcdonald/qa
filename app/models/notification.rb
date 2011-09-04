class Notification < ActiveRecord::Base
  belongs_to :user
  serialize :parameters
  scope :active, where('dismissed = ?', false)

  def self.dismiss!(id)
    n = Notification.find(id)
    n.dismiss = true
    n.save
  end
end
