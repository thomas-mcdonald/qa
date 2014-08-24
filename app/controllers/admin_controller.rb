class AdminController < ApplicationController
  before_filter :require_login

  def index
    @issues = AdminDashboardProblems.new.problems?
  end

  def health
    @problems = AdminDashboardProblems.new.problems
  end
end
