require_dependency 'qa'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :allow_mini_profiler

  private

  def allow_mini_profiler
    Rack::MiniProfiler.authorize_request
  end

  def current_user
    @current_user ||= User.where('id = ?', session[:user_id]).first if session[:user_id]
  end

  def require_login
    raise QA::NotLoggedIn unless current_user.present?
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !!session[:user_id]
  end
  helper_method :logged_in?

  rescue_from QA::NotLoggedIn do |e|
    raise e if Rails.env.test?
    redirect_to '/'
  end
end