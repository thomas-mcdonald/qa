class NotificationsController < ApplicationController
  before_filter :login_required

  def show
    n = current_user.notifications.find(params[:id])
    n.dismissed = true
    n.save
    redirect_to n.redirect
  end

  def dismiss
    Notification.dismiss!(params[:id], current_user)
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :json => { :dismiss => n.id }.to_json }
    end
  end
end
