# Responsible for creating votes
class VoteCreator

  attr_reader :errors

  def self.create(user, opts = {})
    self.new(user, opts).create
  end

  # Creates a vote
  # user - the user creating the vote
  # opts - hash of options
  #  post_id   - id of the post
  #  post_type - type of post
  #  type_id - type of vote
  def initialize(user, opts = {})
    raise ArgumentError unless user
    [:post_id, :post_type, :vote_type].each { |k| raise ArgumentError, "#{k} is missing" unless opts[k] }
    @user = user
    @vote_params = opts.slice(:post_id, :post_type, :vote_type)
  end

  def create
    @vote = nil

    Vote.transaction do
      create_vote
      update_post_vote_count
      create_reputation_events
      queue_processing
    end

    @vote
  end

  private

  def create_vote
    @vote = @user.votes.new(@vote_params)
    if !@vote.save
      @errors = @vote.errors
      raise ActiveRecord::Rollback
    end
  end

  def update_post_vote_count
    @vote.post.update_vote_count!
  end

  # Create the reputation events for the users involved in the vote
  def create_reputation_events
    ReputationEvent.create_on_receive_vote(@vote)
    ReputationEvent.create_on_give_vote(@vote)
  end

  # process the vote for badges
  def queue_processing
    if @vote_params[:post_type] == 'Answer'
      queue_badge_job(:answer_vote)
    elsif @vote_params[:post_type] == 'Question'
      queue_badge_job(:question_vote)
    end
  end

  def queue_badge_job(badge_type)
    Jobs::Badge.perform_async(badge_type, @vote.post.to_global_id)
  end
end
