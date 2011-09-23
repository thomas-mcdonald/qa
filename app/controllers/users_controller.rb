class UsersController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :new, :create]

  def index
    @users = User.order('repuation_cache DESC')
  end

  def show
    @user = User.find(params[:id])
    @total_questions = @user.questions
    @total_answers = @user.answers
    @questions = @total_questions.page(params[:question_page]).includes(:votes, :tags)
    @answers = @user.answers.all
    @votes = @user.votes.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.username = params[:user][:username] if params[:user]
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end
end
