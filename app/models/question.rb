class Question < ActiveRecord::Base
  attr_accessible :body, :title, :user_id
end
