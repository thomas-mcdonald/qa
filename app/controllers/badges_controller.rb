class BadgesController < ApplicationController

  def index
    @badges = Badge.all_badges
  end
  
  def show
    @badge = Badge.new_from_param(params[:id])
    @count = Badge.param_token(params[:id]).count
    @badges = Badge.param_token(params[:id]).page(params[:page])
  end
end
