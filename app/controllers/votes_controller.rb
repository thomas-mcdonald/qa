require_dependency 'vote_creator'

class VotesController < ApplicationController
  before_filter :json_require_login

  def create
    creator = VoteCreator.new(current_user, vote_params)
    @vote = creator.create
    if creator.errors.blank?
      render_json_partial('votes/destroy', { vote: @vote }, count: @vote.post.vote_count)
    else
      render json: { errors: @vote.errors.full_messages }, status: 422
    end
  end

  def destroy
    @vote = current_user.votes.find(params[:id]).destroy
    render_json_partial('votes/create', {
      post: @vote.post,
      vote_type: @vote.vote_type
    }, count: @vote.post.vote_count)
  end

  private

  def json_require_login
    if !logged_in?
      render json: { errors: 'You must be logged in to vote' }, status: 401 and return
    end
  end

  def vote_params
    params.require(:vote).permit(:post_id, :post_type, :vote_type)
  end
end