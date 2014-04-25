class AdminDashboardProblems
  def problems
    [sidekiq].compact
  end

  private

  def sidekiq
    'No Sidekiq workers appear to be available. Is Sidekiq running?' if Sidekiq::Workers.new.size == 0
  end
end
