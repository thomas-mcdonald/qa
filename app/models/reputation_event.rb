class ReputationEvent < ActiveRecord::Base
  belongs_to :action, polymorphic: true
  belongs_to :user

  # Create the reputation event constants
  _invert = []
  %w(receive_question_upvote receive_question_downvote receive_answer_upvote
    receive_answer_downvote give_question_upvote give_question_downvote
    give_answer_upvote give_answer_downvote accept_answer accepted_answer
  ).each_with_index do |str, i|
    self.const_set(str.upcase, i + 1)
    _invert[i+1] = str
  end
  INVERT = _invert.freeze

  # Given an event type ID, returns the rep change associated with the ID
  def self.reputation_for(id)
    ReputationValues[INVERT[id]]
  end

  # Given a vote, create a reputation event on the user who created the post
  # and recalculate his reputation.
  def self.create_on_receive_vote(vote)
    event = vote.post.user.reputation_events.create(
      action: vote,
      event_type: ReputationEvent.const_get(%(receive_#{vote.event_type}).upcase)
    )
    vote.post.user.calculate_reputation!
    event
  end

  # Given a vote, create a reputation event on the user who created the vote
  # and recalculate his reputation
  def self.create_on_give_vote(vote)
    event = vote.user.reputation_events.create(
      action: vote,
      event_type: ReputationEvent.const_get(%(give_#{vote.event_type}).upcase)
    )
    vote.user.calculate_reputation!
    event
  end
end