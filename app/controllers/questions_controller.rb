class QuestionsController < ApplicationController
  before_filter :require_login, only: [:new, :create]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
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
end