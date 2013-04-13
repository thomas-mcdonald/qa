class QuestionsController < ApplicationController
  before_filter :require_login, only: [:new, :create, :edit, :update]
  before_filter :load_and_verify_slug, only: [:show]

  def index
    @questions = Question.includes(:tags, :user).page(params[:page]).load
  end

  def show
    @question.viewed_by(request.remote_ip)
    @answers = @question.answers
    @user_votes = @question.votes_on_self_and_answers_by_user(current_user)
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.update_last_activity(current_user)
    @question.user = current_user
    if @question.save
      redirect_to @question
    else
      render 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes!(question_params)
    @question.update_last_activity(current_user)
    @question.save
    redirect_to @question
  end

  private

  def load_and_verify_slug
    @question = Question.includes(:votes).find(params[:id])
    if params[:slug] != @question.slug
      redirect_to @question
    end
  end

  def question_params
    params.require(:question).permit(:body, :tag_list, :title)
  end
end