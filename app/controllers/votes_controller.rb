class VotesController < ApplicationController
  before_filter :require_login

  def create
    @vote = current_user.votes.new(vote_params)
    if @vote.save
      render partial: 'votes/destroy', layout: false, locals: { vote: @vote }
    else
      render json: { errors: @vote.errors.full_messages }, status: 422
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:post_id, :post_type, :vote_type_id)
  end
end