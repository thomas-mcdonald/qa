class NotificationsController < ApplicationController
  def show
    n = Notification.find(params[:id])
    n.dismissed = true
    n.save
    redirect_to n.redirect
  end

  def dismiss
    Notification.dismiss!(params[:id])
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { render :json => { :dismiss => n.id }.to_json }
    end
  end
end
