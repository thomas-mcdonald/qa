class AdminController < ApplicationController
  before_filter :require_login

  def index
    @issues = AdminDashboard.new.problems?
  end

  def health
    @problems = AdminDashboard.new.problems
  end
end
