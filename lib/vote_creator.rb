class VoteCreator
  attr_reader :recalculate

  # Creates a vote
  # user - the user creating the vote
  # opts - hash of options
  #  post_id   - id of the post
  #  post_type - type of post
  #  type_id - type of vote
  #  recalculate : Boolean - true - do we recalculate the users reputation?
  def initialize(user, opts = {})
    raise ArgumentError unless user
    [:post_id, :post_type, :vote_type_id].each { |k| raise ArgumentError, "#{k} is missing" unless opts[k] }
    @user = user
    @vote_params = opts.slice(:post_id, :post_type, :vote_type_id)
    @recalculate = opts[:recalculate] || true
  end

  def create
    @user.votes.new(@vote_params)
  end
end