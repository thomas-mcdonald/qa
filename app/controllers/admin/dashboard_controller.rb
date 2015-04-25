class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    db = AdminDashboard.new
    @issues = db.problems?
    @stats = db.stats
  end

  def health
    @problems = AdminDashboard.new.problems
  end
end
