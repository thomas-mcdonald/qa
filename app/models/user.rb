class User < ActiveRecord::Base
  has_many :authorizations
  attr_accessible :email, :name
end
