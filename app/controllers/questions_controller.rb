class QuestionsController < ApplicationController
  before_filter :require_login, only: [:new, :create, :edit, :update]
  before_filter :load_and_verify_slug, only: [:show]

  def index
    @questions = Question.includes(:user).page(params[:page]).load
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    @question.save
    redirect_to @question
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes!(question_params)
    @question.save
    redirect_to @question
  end

  private

  def load_and_verify_slug
    @question = Question.find(params[:id])
    if params[:slug] != @question.slug
      redirect_to @question
    end
  end

  def question_params
    params.require(:question).permit(:body, :title)
  end
end