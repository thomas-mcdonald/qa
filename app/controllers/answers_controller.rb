class AnswersController < ApplicationController
  before_filter :login_required

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(params[:answer])
    @answer.user = current_user
    @question.update_last_activity!(current_user)
    if @answer.save
      Resque.enqueue(Async::Badges::CreateAnswer, @answer.id)
      Rails.logger.info("Queued answer for processing")
    end
    redirect_to @question
  end
end
