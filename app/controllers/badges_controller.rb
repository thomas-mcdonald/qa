class BadgesController < ApplicationController

  def index
    @badges = Badge.all_badges
  end
  
  def show
    if params[:id].to_i == 0
      @badge = Badge.new_from_param(params[:id])
      @count = Badge.param_token(params[:id]).count
      @badges = Badge.param_token(params[:id]).page(params[:page])
    else
      redirect_to Badge.find(params[:id])
    end
  end
end
