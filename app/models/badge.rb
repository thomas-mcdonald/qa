class Badge < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :user

  def badge_definition
    QA::BadgeManager[self.name]
  end

  def name
    self[:name].to_sym
  end
end
