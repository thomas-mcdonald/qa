require_dependency 'qa'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.where('id = ?', session[:user_id]).first if session[:user_id]
  end
  helper_method :current_user

  def require_login
    raise QA::NotLoggedIn unless current_user.present?
  end

  def require_user(user)
    raise QA::NotAuthorised unless current_user.id == user.id
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !!session[:user_id]
  end
  helper_method :logged_in?

  rescue_from QA::NotAuthorised, QA::NotLoggedIn do |e|
    raise e if ENV['RSPEC']
    redirect_to '/'
  end
end