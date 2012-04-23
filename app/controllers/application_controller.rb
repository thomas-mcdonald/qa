class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.where('user_id = ?', session[:user_id]).first if session[:user_id]
  end

  def require_login
    return true if logged_in?
    redirect_to("/login")
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !!session[:user_id]
  end
  helper_method :logged_in?
end