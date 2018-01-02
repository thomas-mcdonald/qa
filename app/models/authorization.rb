class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  def self.create_from_hash(auth_hash)
    auth = create!(
      email: auth_hash[:info][:email],
      provider: auth_hash[:provider],
      uid: auth_hash[:uid]
    )
    auth
  end

  def self.find_by_hash(auth_hash)
    where('uid = ?', auth_hash[:uid]).find_by(provider: auth_hash[:provider])
  end
end
