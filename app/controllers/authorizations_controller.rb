class AuthorizationsController < ApplicationController
  # Acts as a callback
  def callback
    @user = User.new_from_hash(auth_hash)
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end