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

  def self.create_for_receiving_question_upvote(vote, recalculate = true)
    event = vote.post.user.reputation_events.create(
      action: vote,
      event_type: QUESTION_UPVOTE
    )
    vote.post.user.calculate_reputation! if recalculate
    event
  end

  def self.create_for_receiving_question_downvote(vote, recalculate = true)
    event = vote.post.user.reputation_events.create(
      action: vote,
      event_type: QUESTION_DOWNVOTE
    )
    vote.post.user.calculate_reputation! if recalculate
    event
  end
end