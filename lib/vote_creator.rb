class VoteCreator
  # Creates a vote
  # user - the user creating the vote
  # opts - hash of options
  #  post_id   - id of the post
  #  post_type - type of post
  #  type_id - type of vote
  def initialize(user, opts = {})
    raise ArgumentError unless user
    [:post_id, :post_type, :vote_type_id].each { |k| raise ArgumentError, "#{k} is missing" unless opts[k] }
    @user = user
    @vote_params = opts.slice(:post_id, :post_type, :vote_type_id)
  end

  def create
    create_vote
    self.save
    @vote
  end

  def create_vote
    @vote = @user.votes.new(@vote_params)
  end

  def save
    result = false
    Vote.transaction do
      result = @vote.save
      @vote.post.update_vote_count!
      self.create_reputation_events
    end
    result
  end

  # Create the reputation events for the users involved in the vote
  def create_reputation_events
    ReputationEvent.create_on_receive_vote(@vote)
    ReputationEvent.create_on_give_vote(@vote)
  end
end