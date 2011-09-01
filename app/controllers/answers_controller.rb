class AnswersController < ApplicationController
  before_filter :login_required

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(params[:answer])
    @answer.user = current_user
    @answer.save
    redirect_to @question
  end
end
