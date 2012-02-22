class AnswersController < ApplicationController
  before_filter :login_required

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(params[:answer])
    @answer.user = current_user
    @question.update_last_activity!(current_user)
    if @answer.save
      Resque.enqueue(QA::Async::CreateAnswer, @answer.id)
      Rails.logger.info("Queued answer for processing")
    end
    redirect_to @question
  end

  def edit
    @answer = Answer.find(params[:id])
    @question = @answer.question
    authorize! :update, Answer
  end

  def update
    @answer = Answer.find(params[:id])
    authorize! :update, Answer
    @answer.attributes = params[:answer]
    @question = @answer.question
    @question.update_last_activity!(current_user)
    if @answer.save
      Resque.enqueue(QA::Async::EditAnswer, @answer.id)
      redirect_to @question, :notice  => "Successfully updated answer."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    authorize! :destroy, @answer
    @answer.destroy
    redirect_to @answer.question, :notice => "Successfully destroyed answer."
  end

  def restore
    @answer = Answer.find(params[:id])
    authorize! :restore, @answer
    @answer.deleted_at = nil
    @answer.save
    redirect_to @answer.question, :notice => "Restored answer"
  end

  def accept
    @answer = Answer.find(params[:id])
    @question = @answer.question
    unauthorized! if @question.user_id != current_user.id
    @question.accept(@answer)
    @question.save
  end

  def unaccept
    @answer = Answer.find(params[:id])
    @question = @answer.question
    unauthorized! if @question.user_id != current_user.id
    @question.unaccept(@answer)
    @question.save
  end
end
