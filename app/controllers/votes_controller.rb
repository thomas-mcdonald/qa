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
    @vote = Vote.find(params[:id])
    json_unauthorised! and return if !is_user(@vote.user)
    if @vote.locked?
      render json: { errors: 'You may no longer change your vote on this post' }, status: 403
    else
      @vote.destroy
      render_json_partial('votes/create', {
        post: @vote.post,
        vote_type: @vote.vote_type
      }, count: @vote.post.vote_count)
    end
  end

  private

  def json_require_login
    if !logged_in?
      render json: { errors: 'You must be logged in to vote' }, status: 401 and return
    end
  end

  def json_unauthorised!
    render json: { errors: 'You are not authorised to do that'}, status: 403
  end

  def vote_params
    params.require(:vote).permit(:post_id, :post_type, :vote_type)
  end
end
