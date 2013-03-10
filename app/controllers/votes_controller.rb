class VotesController < ApplicationController
  before_filter :require_login

  def create
    @vote = current_user.votes.create(vote_params)
    render json: @vote
  end

  private

  def vote_params
    params.require(:vote).permit(:post_id, :post_type, :vote_type_id)
  end
end