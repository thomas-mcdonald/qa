class CommentsController < ApplicationController
  before_filter :require_login

  def new
    @comment = Comment.new
    render_json_partial('comments/form', {
      comment: @comment,
      post_id: params[:post_id],
      post_type: params[:post_type]
    })
  end

  def create

  end
end
