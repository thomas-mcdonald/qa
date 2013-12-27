class ReputationEvent < ActiveRecord::Base
  belongs_to :action, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:action_id, :action_type] }

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

  before_destroy :queue_recalculate
  after_create :queue_recalculate

  # Given an event type ID, returns the rep change associated with the ID
  def self.reputation_for(id)
    ReputationValues[INVERT[id]]
  end

  def self.create_on_accept_answer(question, answer)
    question.user.reputation_events.create(
      action: question,
      event_type: ReputationEvent::ACCEPT_ANSWER
    )
    answer.user.reputation_events.create(
      action: answer,
      event_type: ReputationEvent::ACCEPTED_ANSWER
    )
  end

  # Given a vote, create a reputation event on the user who created the post
  # and recalculate his reputation.
  def self.create_on_receive_vote(vote)
    event = vote.post.user.reputation_events.create(
      action: vote,
      event_type: ReputationEvent.const_get(%(receive_#{vote.event_type}).upcase)
    )
    event
  end

  # Given a vote, create a reputation event on the user who created the vote
  # and recalculate his reputation
  def self.create_on_give_vote(vote)
    event = vote.user.reputation_events.create(
      action: vote,
      event_type: ReputationEvent.const_get(%(give_#{vote.event_type}).upcase)
    )
    event
  end

  # Queue a recalculation of the users reputation
  # Delayed by 10 seconds to allow for deletion to actually happen.
  def queue_recalculate
    Jobs::CalculateReputation.perform_in(10.seconds, self.user_id)
  end
end