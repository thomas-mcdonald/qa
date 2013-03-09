class Vote < ActiveRecord::Base
  belongs_to :post, polymorphic: true
  belongs_to :user

  TYPES = {
    UPVOTE: 1,
    DOWNVOTE: 2
  }
end