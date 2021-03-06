class CommentsController < ApplicationController
  before_action :require_login

  def new
    @comment = Comment.new
    authorize(@comment)
    render_json_partial('comments/form', {
      comment: @comment,
      post_id: params[:post_id],
      post_type: params[:post_type]
    })
  end

  def create
    @comment = current_user.comments.new(comment_params)
    authorize(@comment)
    if @comment.save
      render_json_partial('comments/comment', {
        comment: @comment
      })
    else
      render json: { errors: @comment.errors.full_messages }, status: 403
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_type, :post_id)
  end
end
