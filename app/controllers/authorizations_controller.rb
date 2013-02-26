class AuthorizationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:callback]

  # Acts as a callback
  def callback
    @user = User.find_by_hash(auth_hash)
    if @user
      login(@user)
      redirect_to "/" and return
    else
      @user = User.new_from_hash(auth_hash)
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end