class ReputationEvent < ApplicationRecord
  belongs_to :action, polymorphic: true
  belongs_to :user

  enum event_type: {
    receive_question_upvote: 1,
    receive_question_downvote: 2,
    receive_answer_upvote: 3,
    receive_answer_downvote: 4,
    give_question_upvote: 5,
    give_question_downvote: 6,
    give_answer_upvote: 7,
    give_answer_downvote: 8,
    accept_answer: 9,
    accepted_answer: 10
  }

  validates :user_id, uniqueness: { scope: [:action_id, :action_type] }

  before_destroy :queue_recalculate
  after_create :queue_recalculate

  def self.types
    event_types
  end

  # Returns the reputation value for a given event type
  def self.reputation_for(key)
    SiteSettings.reputation[key]
  end

  def self.create_on_accept_answer(question, answer)
    create_for_user(question.user, question, :accept_answer)
    create_for_user(answer.user, answer, :accepted_answer)
  end

  # Given a vote, create a reputation event on the user who created the post
  # and recalculate his reputation.
  def self.create_on_receive_vote(vote)
    create_for_user(vote.post.user, vote, %(receive_#{vote.event_type}))
  end

  # Given a vote, create a reputation event on the user who created the vote
  # and recalculate his reputation
  def self.create_on_give_vote(vote)
    create_for_user(vote.user, vote, %(give_#{vote.event_type}))
  end

  def self.create_for_user(user, action, type)
    event = user.reputation_events.create(
      action: action,
      event_type: type
    )
    event
  end

  # Queue a recalculation of the users reputation
  # Delayed by 10 seconds to allow for deletion to actually happen.
  def queue_recalculate
    Jobs::CalculateReputation.perform_in(10.seconds, self.user_id)
  end
end
