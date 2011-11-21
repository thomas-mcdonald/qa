class NotificationsController < ApplicationController
  before_filter :login_required

  def dismiss
    n = Notification.dismiss!(params[:id], current_user)
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :json => { :dismiss => n.id }.to_json }
    end
  end
end
