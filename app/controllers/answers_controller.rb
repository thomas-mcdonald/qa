class AnswersController < ApplicationController
  before_filter :require_login

  def create
    @question = Question.find(params[:answer][:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    redirect_to @answer.question
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update_attributes(answer_params)
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end