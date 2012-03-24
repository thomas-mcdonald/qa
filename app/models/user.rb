class User < ActiveRecord::Base
  has_many :authorizations
  attr_accessible :authorizations_attributes, :email, :name
  accepts_nested_attributes_for :authorizations, allow_destroy: false, reject_if: proc { |obj| obj.blank? }

  def self.new_from_hash(auth_hash)
    user = User.new(
      email: auth_hash.info.email,
      name: auth_hash.info.name
    )
    user.authorizations.new(
      email: auth_hash.info.email,
      provider: auth_hash.provider,
      uid: auth_hash.uid
    )
    user
  end
end