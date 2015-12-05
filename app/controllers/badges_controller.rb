class BadgesController < ApplicationController
  def show
    @badge = QA::BadgeManager[param_to_sym]
    @badge_count = Badge.for(@badge.name).count
    @recent_awards = Badge.for(@badge.name).joins(:user).limit(50)
    render_404 if @badge.nil?
  end

  private

  def param_to_sym
    params[:id].gsub('-', '_').to_sym
  end
end
