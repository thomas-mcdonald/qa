class UsersController < ApplicationController
  before_filter :load_and_verify_slug, only: [:show]
  before_filter :require_login, except: [:index, :show, :new, :create]

  def index
    @users = User.order('reputation DESC').all
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.limit(5)
    @answers = @user.answers.includes(:question).limit(5)
  end

  def new
  end

  def create
    @user = User.create(user_params)
    session[:user_id] = @user.id
    redirect_to "/"
  end

  def edit
    @user = current_user
  end

  def update
    # TODO: allow invalid updates, rerender edit
    raise QA::NotAuthorised if params[:id].to_i != current_user.id
    current_user.update_attributes!(update_params)
    current_user.save
    redirect_to current_user
  end

  private

  def load_and_verify_slug
    @user = User.find(params[:id])
    if !@user.valid_slug?(params[:id])
      redirect_to @user
    end
  end

  def update_params
    params.require(:user).permit(:name, :email, :about_me)
  end

  def user_params
    params.require(:user).permit(:name, :email, authorizations_attributes: [:provider, :email, :uid])
  end
end
