class ReputationEvent < ActiveRecord::Base
  belongs_to :action, polymorphic: true
  belongs_to :user

  TYPES = [
    { action: 'recieve question upvote',
      reputation: 10 },
    { action: 'recieve question downvote',
      reputation: -5 },
    { action: 'recieve answer upvote',
      reputation: 10 },
    { action: 'recieve answer downvote',
      reputation: -5 }
  ]
end