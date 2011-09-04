class NotificationsController < ApplicationController
  def dismiss
    Notification.dismiss!(params[:id])
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :json => { :dismiss => n.id }.to_json }
    end
  end
end
