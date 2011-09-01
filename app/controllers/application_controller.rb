class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery
  
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
