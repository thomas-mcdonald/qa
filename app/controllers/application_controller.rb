class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  before_filter :check_for_notification_id
  before_filter :load_moderation_info
  before_filter :load_notifications

  def load_notifications
    @notifications = []
    @notifications = current_user.active_notifications if logged_in?
  end

  def check_for_notification_id
    if logged_in? && params[:nid] && request.get?
      current_user.notifications.find(params[:nid]).dismiss!
      params[:nid] = nil
      redirect_to request.path, params
    end
  end

  def load_moderation_info 
    if logged_in? && current_user.moderator?
      @flag_count = Flag.active.count
    end
  end

  def moderator_required
    denied if !logged_in? || !current_user.moderator?
  end

  def denied
    redirect_to('/')
  end
end
