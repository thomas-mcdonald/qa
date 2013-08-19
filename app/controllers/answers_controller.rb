require_dependency 'timeline_action'

class AnswersController < ApplicationController
  include TimelineAction

  before_filter :require_login, except: [:timeline]

  def create
    @question = Question.find(params[:answer][:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    redirect_to @answer.question
  end

  def edit
    @answer = Answer.find(params[:id])
    authorize(@answer)
  end

  def update
    @answer = Answer.find(params[:id])
    authorize(@answer)
    @answer.update_attributes(answer_params)
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_timeline_post
    @post = Answer.find(params[:id])
  end
end