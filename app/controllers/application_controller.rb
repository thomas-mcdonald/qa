class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  before_filter :check_for_notification_id
  before_filter :load_moderation_info
  before_filter :load_notifications

  def load_notifications
    @notifications = []
    # TODO: load dismissed notifications as well
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

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403
  end

  def moderator_required
    denied if !logged_in? || !current_user.moderator?
  end

  def denied
    raise CanCan::AccessDenied.new
  end

  def unauthorized!
    denied
  end
end
