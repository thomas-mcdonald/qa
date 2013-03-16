class VotesController < ApplicationController
  before_filter :json_require_login

  def create
    @vote = current_user.votes.new(vote_params)
    if @vote.save
      render json: {
        content: render_to_string(partial: 'votes/destroy', layout: false, locals: { vote: @vote }),
        count: @vote.post.vote_count
      }
    else
      render json: { errors: @vote.errors.full_messages }, status: 422
    end
  end

  def destroy
    @vote = current_user.votes.find(params[:id]).destroy
    render json: {
      content: render_to_string(partial: 'votes/create', layout: false, locals: { post: @vote.post, vote_type_id: @vote.vote_type_id }),
      count: @vote.post.vote_count
    }
  end

  private

  def json_require_login
    if !logged_in?
      render json: { errors: 'You must be logged in to vote' }, status: 401 and return
    end
  end

  def vote_params
    params.require(:vote).permit(:post_id, :post_type, :vote_type_id)
  end
end