class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.create(params[:user])
    redirect_to "/"
  end
end