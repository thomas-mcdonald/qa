class Flag < ActiveRecord::Base
  belongs_to :flaggable, :polymorphic => true
  belongs_to :user

  scope :active, where('dismissed = ?', false)

  validate :should_be_unique
  validates_presence_of :flaggable_type
  validates_numericality_of :flaggable_id, :user_id

  def should_be_unique
    f = Flag.where(:user_id => self.user_id, :flaggable_id => self.flaggable_id, :flaggable_type => self.flaggable_type).first
    v = (f.nil? || f.id = self.id)
    unless v
      self.errors.add(:flaggable, "You have already flagged this #{self.flaggable_type.downcase}")
    end
  end

  def dismiss!
    self.dismissed = true
    self.save
  end
end

