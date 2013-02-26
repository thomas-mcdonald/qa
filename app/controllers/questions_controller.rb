class QuestionsController < ApplicationController
  before_filter :require_login, only: [:new, :create, :edit, :update]
  before_filter :load_and_verify_slug, only: [:show]

  def index
    @questions = Question.includes(:user).all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params[:question])
    @question.user = current_user
    @question.save
    redirect_to '/'
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes!(params[:question])
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
end