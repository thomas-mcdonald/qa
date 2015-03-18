require_dependency 'qa'

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :check_for_orphaned_authorization

  private

  def current_user
    @current_user ||= User.where('id = ?', session[:user_id]).first if session[:user_id]
  end
  helper_method :current_user

  def require_login
    raise QA::NotLoggedIn unless current_user.present?
  end

  def is_user(user)
    logged_in? && current_user.id == user.id
  end
  helper_method :is_user

  def require_user(user)
    raise QA::NotAuthorised unless is_user(user)
  end

  def require_admin
    raise QA::NotAuthorised unless current_user.try(:admin)
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !!session[:user_id]
  end
  helper_method :logged_in?

  # If session[:auth_id] is set outside of the user creation pages, the the
  # visitor has abandoned the user creation process and so we clean up the
  # authorization so it may be used at a later date.
  def check_for_orphaned_authorization
    if session[:auth_id]
      Rails.logger.info "Cleaning up abandoned signup with ID ##{session[:auth_id]}"
      if auth = Authorization.find_by_id(session[:auth_id])
        auth.destroy
      else
        Rails.logger.warn "Tried to delete authorization ##{session[:auth_id]} but it was not found"
      end
      session[:auth_id] = nil
    end
  end

  def render_json_partial(name, locals, extras = {})
    render json: {
      content: render_to_string(partial: name, formats: [:html], layout: false, locals: locals)
    }.merge(extras)
  end

  # This feels a bit hacky
  def handle_env(e)
    raise e if ENV['RSPEC']
  end

  rescue_from QA::NotAuthorised do |e|
    handle_env(e)
    flash[:error] = "Sorry, you can't do that"
    redirect_to '/'
  end

  rescue_from QA::NotLoggedIn do |e|
    handle_env(e)
    # TODO: display inside opened login modal
    flash[:notice] = "You must be logged in to perform that action"
    redirect_to '/'
  end
end
