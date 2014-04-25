class AdminController < ApplicationController
  before_filter :require_login

  def index
    @problems = AdminDashboardProblems.new.problems
  end
end
