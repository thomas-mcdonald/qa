class NotificationsController < ApplicationController
  def dismiss
    n = Notification.find(params[:id])
    n.dismissed = true
    n.save
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :json => { :dismiss => n.id }.to_json }
    end
  end
end
