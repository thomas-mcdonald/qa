class ReputationEvent < ActiveRecord::Base
  belongs_to :action, polymorphic: true
  belongs_to :user

  QUESTION_UPVOTE = 1
  QUESTION_DOWNVOTE = 2
  INVERT = ['question_upvote', 'question_downvote'].unshift(nil).freeze

  # Given an event type ID, returns the rep change associated with the ID
  def self.reputation_for(id)
    ReputationValues[INVERT[id]]
  end

  def self.create_for_receiving_question_upvote(vote)
    event = vote.post.user.reputation_events.create(
      action: vote,
      event_type: QUESTION_UPVOTE
    )
    vote.post.user.calculate_reputation!
    event
  end

  def self.create_for_receiving_question_downvote(vote)
    event = vote.post.user.reputation_events.create(
      action: vote,
      event_type: QUESTION_DOWNVOTE
    )
    vote.post.user.calculate_reputation!
    event
  end
end