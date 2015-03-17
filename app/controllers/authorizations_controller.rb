class AuthorizationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]

  # Acts as a callback
  def callback
    @user = User.find_by_hash(auth_hash)
    if @user
      login(@user)
      redirect_to "/" and return
    else
      # We store the authorization so that the user cannot modify
      # the provider/uid details in the form
      @authorization = Authorization.create_from_hash(auth_hash)
      session[:auth_id] = @authorization.id
      @user = User.new_from_hash(auth_hash)
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
