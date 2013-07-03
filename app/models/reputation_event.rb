class ReputationEvent < ActiveRecord::Base
  belongs_to :action, polymorphic: true
  belongs_to :user

  QUESTION_UPVOTE = 1
  QUESTION_DOWNVOTE = 2
  ANSWER_UPVOTE = 3
  ANSWER_DOWNVOTE = 4
  INVERT = ['question_upvote', 'question_downvote'].unshift(nil).freeze

  # Given an event type ID, returns the rep change associated with the ID
  def self.reputation_for(id)
    ReputationValues[INVERT[id]]
  end

  # Given a vote, create a reputation event on the user who created the post
  # and recalculate his reputation.
  def self.create_on_receive_vote(vote)
    event = vote.post.user.reputation_events.create(
      action: vote,
      event_type: vote.reputation_event_type
    )
    vote.post.user.calculate_reputation!
    event
  end
end