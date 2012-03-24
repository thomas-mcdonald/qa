class Authorization < ActiveRecord::Base
  belongs_to :user
  attr_accessible :email, :provider, :uid
end