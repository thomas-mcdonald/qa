class Notification < ActiveRecord::Base
  belongs_to :user
  serialize :parameters
  scope :active, where('dismissed = ?', false)
end
