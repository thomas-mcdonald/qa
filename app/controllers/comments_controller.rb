class CommentsController < ApplicationController
  before_filter :login_required

  def new
    @item = Question.find(params[:question_id]) if params[:question_id]
    @item = Answer.find(params[:answer_id]) if params[:answer_id]
    @comment = @item.comments.new
    render :new, :layout => false
  end

  def create
    @comment = current_user.comments.new(params[:comment])
    if @comment.save
      render :json => render_to_string(:partial => 'comments/comment', :locals => { :comment => @comment }).to_json
    end
  end
end
