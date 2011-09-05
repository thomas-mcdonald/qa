class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  before_filter :load_notifications

  def load_notifications
    @notifications = []
    @notifications = current_user.active_notifications if logged_in?
  end

  def admin_required
    if !logged_in? || !current_user.admin?
      denied
    end
  end

  def moderator_required
    if !logged_in? || !current_user.moderator?
      denied
    end
  end

  def denied
    redirect_to('/')
  end
end
