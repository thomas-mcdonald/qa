class UsersController < ApplicationController
  before_filter :load_and_verify_slug, only: [:show]

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.limit(5)
    @answers = @user.answers.limit(5)
  end

  def new
  end

  def create
    @user = User.create(user_params)
    session[:user_id] = @user.id
    redirect_to "/"
  end

  private

  def load_and_verify_slug
    @user = User.find(params[:id])
    if params[:slug] != @user.slug
      redirect_to @user
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, authorizations_attributes: [:provider, :email, :uid])
  end
end