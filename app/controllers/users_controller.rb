class UsersController < ApplicationController
  def new
  end

  def confirm
    @user = User.new_from_hash(auth_hash)
  end

  def create
    @user = User.create(params[:user])
    redirect_to "/"
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
