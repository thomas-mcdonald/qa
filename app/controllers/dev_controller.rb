class DevController < ApplicationController
  def login
    session[:user_id] = params[:as].to_i
    redirect_to '/'
  end
end