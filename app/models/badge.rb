class Badge < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :user

  validates :name, presence: true

  def badge_definition
    QA::BadgeManager[self.name]
  end

  def badge_type
    badge_definition.type
  end

  def name
    self[:name].try(:to_sym)
  end
end
