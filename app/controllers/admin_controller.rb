class AdminController < ApplicationController
  before_filter :require_login

  def index
    db = AdminDashboard.new
    @issues = db.problems?
    @stats = db.stats
  end

  def health
    @problems = AdminDashboard.new.problems
  end
end
