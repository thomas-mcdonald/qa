class ReputationEvent < ActiveRecord::Base
  belongs_to :action, polymorphic: true
  belongs_to :user

  TYPES = [
    { action: 'receive question upvote',
      reputation: 10 },
    { action: 'receive question downvote',
      reputation: -5 },
    { action: 'receive answer upvote',
      reputation: 10 },
    { action: 'receive answer downvote',
      reputation: -5 }
  ]
end