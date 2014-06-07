class CommentsController < ApplicationController
  before_filter :require_login

  def new
    @comment = Comment.new
    render_json_partial('comments/form', {
      comment: @comment
    })
  end

  def create

  end
end
