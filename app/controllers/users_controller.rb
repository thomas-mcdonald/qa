class UsersController < ApplicationController
  before_filter :load_and_verify_slug, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def create
    @user = User.create(params[:user])
    redirect_to "/"
  end

  private

  def load_and_verify_slug
    @user = User.find(params[:id])
    if params[:slug] != @user.slug
      redirect_to @user
    end
  end
end