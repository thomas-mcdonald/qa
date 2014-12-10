class AdminDashboardProblems
  def problems
    [sidekiq].compact
  end

  def problems?
    problems.length > 0
  end

  private

  def sidekiq
    'No Sidekiq workers appear to be available. Is Sidekiq running?' if Sidekiq::ProcessSet.new.size == 0
  end
end
