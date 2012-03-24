class UsersController < ApplicationController
  def new
  end

  def confirm
    @user = User.new_from_hash(auth_hash)
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
